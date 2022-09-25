#!/usr/bin/env python3

from multiprocessing.context import Process
from loguru import logger
import subprocess
import boto3
import re
import os

import argparse


def get_credentials(profile_name):
    """
    use okta and aws profile to generate credentials
    :param profile_name: string
    :return: map of role credentials from the profile
    """

    logger.info(f"Getting credentials for {profile_name} account")

    credentials = {}
    env = profile_name

    cmd1 = (
        "aws-okta exec %s -- printenv | grep -E '(AWS_ACCESS_KEY_ID)'|cut -d'=' -f2,3"
        % env
    )
    cmd2 = (
        "aws-okta exec %s -- printenv | grep -E '(AWS_SECRET_ACCESS_KEY)'|cut -d'=' -f2,3"
        % env
    )
    cmd3 = (
        "aws-okta exec %s -- printenv | grep -E '(AWS_SESSION_TOKEN)'|cut -d'=' -f2,3"
        % env
    )

    key = subprocess.getoutput(cmd1)
    secret = subprocess.getoutput(cmd2)
    token = subprocess.getoutput(cmd3)

    credentials["key"] = key
    credentials["secret"] = secret
    credentials["token"] = token

    return credentials


def get_users(iam):
    """
    get all users per account
    :param iam: credentials for the account
    """

    logger.info(f"Retrieving users")

    response = iam.list_users()

    users = []
    for u in response["Users"]:
        # print(u) #CreateDate UserName
        users.append(u.get("UserName"))

    my_user_data = {}

    for u in users:
        user = iam.list_access_keys(UserName=u)
        if user.get("AccessKeyMetadata") != []:
            user_name = user.get("AccessKeyMetadata")[0].get("UserName")
            user_status = user.get("AccessKeyMetadata")[0].get("Status")
            user_create_date = user.get("AccessKeyMetadata")[0].get("CreateDate")
            user_access_key_id = user.get("AccessKeyMetadata")[0].get("AccessKeyId")
        else:
            user_name = u
            user_status = "no key"
            user_create_date = "no key"
            user_access_key_id = "no key"

        # print(
        #     f'{user_name : <46} {user_status : <10} {user_access_key_id} {user_create_date}')

        # build a map

        my_user_data[user_name] = {
            "status": user_status,
            "access_key": user_access_key_id,
            "user_create_date": user_create_date,
        }

    # for user, v in my_user_data.items():
    #     print(f"{user : <46} {v.get('status') : <10} {v.get('access_key')} {v.get('user_create_date').strftime('%Y-%m-%d')}")
    return my_user_data


def get_users_data(iam, my_user_data):
    """
    get report for each user
    :param iam: credentials for the account
    :my_user_data: map containing users and data
    """

    logger.info(f"Retrieving user data")
    print("### Groups Assignment")
    print(f'{"|User":<46}{"|Group":<24}')
    print("--- | --- |")
    for k, v in my_user_data.items():
        my_u = iam.list_groups_for_user(UserName=k)
        if len(my_u.get("Groups")) != 0:
            groups = []
            for g in range(len(my_u.get("Groups"))):
                groups.append(my_u.get("Groups")[g].get("GroupName"))
            print(f"{k : <46} |{groups}")
        else:
            print(f'{k : <46}| {"---------------"}')

    print()
    print("### User Key Data")
    print(
        f'{"|User":<46}{"|Access Key":<24}{"|Access Key Time":<11} {"|User Create Time|"}'
    )
    print("--- | --- | --- | ---")
    for user, data in my_user_data.items():
        user_access_key_id = data.get("access_key")
        user_create_date = data.get("user_create_date")
        if user_access_key_id != "no key":
            key_data = iam.get_access_key_last_used(AccessKeyId=user_access_key_id)

            last_key_data_use = key_data.get("AccessKeyLastUsed").get("LastUsedDate")

            if last_key_data_use is None:
                key_time = "Never Used"
            else:

                key_time = last_key_data_use.strftime("%Y-%m-%d")
            user_time = user_create_date.strftime("%Y-%m-%d")

            print(
                f'{key_data.get("UserName"):<46}|{user_access_key_id:<10}|\t{key_time}|\t{user_time:<10}'
            )
        else:
            user_time = user_create_date
            print(f"{user:<46}|{'NO Key':<10}|\t{'NO Key':<10}|\t{'NO Key'}")


def get_all_profiles(aws_config):
    """Create a list of profiles located in the user's aws config"""
    list_of_profiles = []
    pattern = re.compile(r"^\[(.*?)\]")
    with open(os.path.expanduser(f"~/.aws/{aws_config}")) as f:
        lines = f.readlines()
    for line in lines:
        profiles = pattern.findall(line)
        for profile in profiles:
            if profile in [
                "okta",
                "default",
                "profile template",
                "profile grpn-geekon-dev",
            ]:
                continue
            list_of_profiles.append((profile.replace("profile ", "")))
    return list_of_profiles


def start_job(profile):
    print(f"## Audit for: {profile}")
    print()
    try:
        credentials = get_credentials(profile)
        iam = boto3.client(
            "iam",
            aws_access_key_id=credentials.get("key"),
            aws_secret_access_key=credentials.get("secret"),
            aws_session_token=credentials.get("token"),
        )
        my_user_data = get_users(iam)
        get_users_data(iam, my_user_data)
        print()
    except Exception as e:
        logger.info(f"Error in profile: {profile} {e}")


def main():
    parser = argparse.ArgumentParser(description="AWS config file")
    parser.add_argument(
        "--config", type=str, help="aws profile file e.g. 'landing-zone.config'"
    )
    args = parser.parse_args()

    aws_config_file = args.config  # "landing-zone.config"

    accounts = get_all_profiles(aws_config_file)
    processes = []

    for profile in accounts:
        proc = Process(target=start_job, args=(profile,))
        processes.append(proc)
        proc.start()
        # complete the processes
    for p in processes:
        proc.join()


if __name__ == "__main__":
    main()
