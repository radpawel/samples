import argparse


def parser_this():
    region_targets = ["us-west-1", "us-west-2", "us-east-1", "eu-west-2", "eu-west-1"]
    parser = argparse.ArgumentParser(
        description="Role Access Analyzer",
        usage="python main.py -p gensandbox -r AWSBackupDefaultServiceRole",
    )
    parser.add_argument(
        "-p",
        "--profile",
        dest="profile",
        metavar="aws profile name",
        required=True,
    )
    parser.add_argument(
        "-r",
        "--role",
        dest="role",
        metavar="aws iam role name",
        required=True,
    )
    parser.add_argument(
        "-v",
        "--verbose",
        dest="verbose",
        help="verbose mode",
        action="store_true",
    )
    parser.add_argument(
        "-d",
        "--days",
        dest="days",
        metavar="Number of day logs from CloudTrail bucket",
        type=int,
        choices=range(1, 30),
    )
    parser.add_argument(
        "--region",
        dest="region",
        default=region_targets,
        choices=region_targets,
        nargs="+",
    )

    args = parser.parse_args()

    return args
