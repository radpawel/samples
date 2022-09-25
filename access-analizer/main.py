#!/usr/bin/env  python
import my_argparser
from botocore.exceptions import ClientError
import boto3
import datetime
from datetime import datetime, timedelta, timezone
import json
from loguru import logger
import os
import re
import subprocess
import sys
import time


@logger.catch
def get_all_profiles(aws_config):
    """
    Create a list of profiles located in the user's aws config
    :aws_config: aws config file
    :return: list of profiles
    """

    list_of_profiles = []
    pattern = re.compile(r"\[(.*?)\]")
    with open(os.path.expanduser(f"~/.aws/{aws_config}")) as f:
        lines = f.readlines()
    for line in lines:
        profiles = pattern.findall(line)
        for profile in profiles:
            if profile in [
                "okta",
                "default",
                "profile grpn-geekon-dev",
                "profile template",
                "profile custom",
            ]:
                continue
            list_of_profiles.append((profile.replace("profile ", "")))
    return list_of_profiles


@logger.catch
def get_credentials(profile_name):
    """
    use okta and aws profile to generate credentials
    :profile_name: string
    :return: map of role credentials from the profile and account
    """

    logger.info(f"Requiring credentials for {profile_name} account")

    credentials = {}
    key = f"aws-okta exec {profile_name} -- printenv | grep -E '(AWS_ACCESS_KEY_ID)'|cut -d'=' -f2,3"
    secret = f"aws-okta exec {profile_name} -- printenv | grep -E '(AWS_SECRET_ACCESS_KEY)'|cut -d'=' -f2,3"
    token = f"aws-okta exec {profile_name} -- printenv | grep -E '(AWS_SESSION_TOKEN)'|cut -d'=' -f2,3"
    account = f"aws-okta exec {profile_name} -- aws sts get-caller-identity --query 'Account' --output text"

    credentials["key"] = subprocess.getoutput(key)
    credentials["secret"] = subprocess.getoutput(secret)
    credentials["token"] = subprocess.getoutput(token)
    credentials["account"] = subprocess.getoutput(account)

    return credentials


@logger.catch
def generate_job(session, role_name, endtime, starttime, region, account):
    """
    generate policy based on CloudTrail events in the region
    :credentials: map of credentials for a role running script
    :role_name:  string of role name for which to generate a policy
    :endtime: string of end time cloudTrailDetails
    :starttime: string of start time for cloudTrailDetails
    :region: string of region for cloudTrailDetails
    :account: string of the account number
    :return: string of policy id
    """

    logger.info(f"Generating policy for {role_name} from {region}")

    trail = "arn:aws:cloudtrail:us-west-2:248184355264:trail/GRPNOrganizationTrail"
    trail_role = f"arn:aws:iam::{account}:role/grpn-all-access-analyzer-monitor"
    access_analyzer = session.client("accessanalyzer")

    logger.info(f"Policy Generation: Start {starttime} - End {endtime}")

    response = access_analyzer.start_policy_generation(
        cloudTrailDetails={
            "accessRole": trail_role,
            "endTime": endtime,
            "startTime": starttime,
            "trails": [
                {
                    "cloudTrailArn": trail,
                    "regions": region,
                },
            ],
        },
        policyGenerationDetails={
            "principalArn": f"arn:aws:iam::{account}:role/{role_name}"
        },
    )
    response = (response.get("jobId"), response.get("ResponseMetadata"))

    return response


@logger.catch
def get_policy(session, job_id, verbose):
    """
    get policy generated for a role
    :credentials: map of credentials for a role running script
    :job_id: string of generated job id
    :return: role policy
    """
    logger.info(f"Retrieving generated policy: {job_id}")

    generated_policies = []
    policy_formatted_str = ""

    access_analyzer = session.client("accessanalyzer")

    response = access_analyzer.get_generated_policy(
        includeResourcePlaceholders=True,
        includeServiceLevelTemplate=True,
        jobId=job_id,
    )
    if verbose:
        logger.info(f'GeneratedPolicyResult: {response.get("generatedPolicyResult")}')
        logger.info(f'JobDetails: {response.get("jobDetails")}')
        logger.info(f'JobStatus: {response.get("jobDetails").get("status")}')

    status = response.get("jobDetails").get("status")
    # "IN_PROGRESS", "SUCCEEDED"
    while status == "IN_PROGRESS":
        time.sleep(30)
        response = access_analyzer.get_generated_policy(
            includeResourcePlaceholders=True,
            includeServiceLevelTemplate=True,
            jobId=job_id,
        )
        status = response.get("jobDetails").get("status")
        logger.info(f"Job status {status}")
        if verbose:
            logger.info(response)

    if "FAILED" in status:
        error = response["jobDetails"]["jobError"]
        policy_formatted_str = json.dumps(error, indent=4)
        start = response["generatedPolicyResult"]["properties"]["cloudTrailProperties"][
            "startTime"
        ]
        end = response["generatedPolicyResult"]["properties"]["cloudTrailProperties"][
            "endTime"
        ]

        logger.info(f"Accessing logs between :{start} - {end}")

    elif (
        "SUCCEEDED" in status and response["generatedPolicyResult"]["generatedPolicies"]
    ):
        for p in response["generatedPolicyResult"]["generatedPolicies"]:
            generated_policies.append(json.loads(p.get("policy")))
            policy_formatted_str = json.dumps(generated_policies, indent=4)
    elif (
        "SUCCEEDED" in status
        and not response["generatedPolicyResult"]["generatedPolicies"]
    ):
        policy_data = "Job was successful but there is not policy data, check last role activity and adjust time span"
        policy_formatted_str = policy_data

    else:
        policy_data = response["generatedPolicyResult"]["generatedPolicies"]
        obj = json.loads(policy_data)
        policy_formatted_str = json.dumps(obj, indent=4)

    return policy_formatted_str


def get_role_info(session, role_name, time_now):
    """
    get number of days when a role was accessed last time
    :credentials: map of credential
    :role_name: string of role name
    :time_now: datetime object
    :returns: number of days a role was last accessed
    """

    days = 0
    iam = session.resource("iam")
    try:
        role = iam.Role(role_name)

        # check role last activity (e.g. Last activity None == {})
        # if there is activity but days are 0 treat it as 1 day (e.g. Last activity 33 minutes ago)
        if role.role_last_used:
            last_used = role.role_last_used.get("LastUsedDate")
            last_region = role.role_last_used.get("Region")

            logger.info(
                f"{role_name},last access time: {datetime.strftime(last_used, '%Y-%m-%d')} in {last_region}"
            )
            last_time_delta = time_now - last_used

            if last_time_delta.days == 0:
                days = 1
            else:
                days = last_time_delta.days
    except ClientError as e:
        logger.error(e)

    return days


@logger.catch
def main():

    args = my_argparser.parser_this()

    print(args)
    if args.days is None:
        args.days = 29

    tdelta = timedelta(days=args.days)
    tnow = datetime.now().replace(tzinfo=timezone.utc)
    tspan = tnow - tdelta
    ct_starttime = tspan.strftime("%Y-%m-%dT%H:%M:%S")
    ct_endtime = tnow.strftime("%Y-%m-%dT%H:%M:%S")

    logger.info(
        f"Checking logs between {tspan.strftime('%Y-%m-%d')} - {tnow.strftime('%Y-%m-%d')}, Total: {tdelta.days} days"
    )

    # Default profile for AWSLandingZone
    profiles = get_all_profiles("landing-zone.config")

    if args.profile in profiles:
        if args.verbose:
            logger.info(f"Checking {args.profile} profile")

        credentials = get_credentials(args.profile)

        session = boto3.Session(
            aws_access_key_id=credentials.get("key"),
            aws_secret_access_key=credentials.get("secret"),
            aws_session_token=credentials.get("token"),
            region_name="us-west-2",
        )

        days_role_last_access = get_role_info(
            session, args.role, tnow.replace(tzinfo=timezone.utc)
        )

        if days_role_last_access > args.days or days_role_last_access == 0:
            logger.info(
                f"{args.role} last access time was {days_role_last_access} days ago, no data in CloudTrail"
            )
            sys.exit()
        else:
            r = generate_job(
                session,
                args.role,
                ct_endtime,
                ct_starttime,
                args.region,
                credentials.get("account"),
            )

            job_id = r[0]
            policy = get_policy(session, job_id, args.verbose)
            print(policy)

    else:
        logger.info(
            f"Profile: {args.profile} does not exist in  check your profile file"
        )


if __name__ == "__main__":
    main()

## Notes:
# grpn-all-backup-operator
# grpn-sandbox-dev-geekon-grouponx
# grpn-sandbox-dev-geekonbuy-lambda ->no activity
# ct_starttime = "2022-01-20T11:11:00"
# ct_endtime = "2022-02-19T11:11:00"
# grpn-all-general-ro
# grpn-all-backup-operator
