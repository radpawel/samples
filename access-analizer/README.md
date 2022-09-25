### Usage

pip install -r requirements.txt

Defaults:
- Time span in days to check CloudTrail logs is set to 29 days, use `-d` flag to override the value
- Access Analyzer will check 5 regions `['us-west-1', 'us-west-2', 'us-east-1', 'eu-west-2', 'eu-west-1']`, use --region flag to override the value 


### Limitations:
- Quota on number of log files is set tp 100,000 - this prevents Analyzer on check all regions at the same time
- Quota on number of concurrent jobs is set to one - one job per account can be run at the same time

### Examples

    ➜ python main.py -h
    usage: python main.py -p gensandbox -r AWSBackupDefaultServiceRole
    
    Role Access Analyzer
    
    options:
      -h, --help            show this help message and exit
      -p aws profile name, --profile aws profile name
      -r aws iam role name, --role aws iam role name
      -v, --verbose         verbose mode
      -d Number of day logs from CloudTrail bucket, --days Number of day logs from CloudTrail bucket
      --region {us-west-1,us-west-2,us-east-1,eu-west-2,eu-west-1}


    ➜ python main.py -p gensandbox -r grpn-sandbox-dev-geekonbuy-lambda  --region us-west-2 -d 4
    2022-02-21 12:51:04.557 | INFO     | __main__:main:311 - Checking logs between 2022-02-17 - 2022-02-21, Total: 4 days
    2022-02-21 12:51:04.558 | INFO     | __main__:get_credentials:50 - Requiring credentials for gensandbox account
    2022-02-21 12:51:13.869 | INFO     | __main__:main:328 - grpn-sandbox-dev-geekonbuy-lambda last access time was 0 days ago, no data in CloudTrail


    python main.py -p gensandbox -r grpn-sandbox-general-dev  --region us-west-2 -d 7
    2022-02-21 13:00:25.751 | INFO     | __main__:main:311 - Checking logs between 2022-02-14 - 2022-02-21, Total: 7 days
    2022-02-21 13:00:25.752 | INFO     | __main__:get_credentials:50 - Requiring credentials for gensandbox account
    2022-02-21 13:00:31.300 | INFO     | __main__:get_role_info:241 - grpn-sandbox-general-dev,last access time: 2022-02-21 in us-west-2
    2022-02-21 13:00:31.302 | INFO     | __main__:generate_job:99 - Generating policy for grpn-sandbox-general-dev
    2022-02-21 13:00:32.566 | INFO     | __main__:get_policy:147 - Retrieving generated policy: ca382bce-ce32-49a6-b8d4-8e713a1389ec
    2022-02-21 13:01:03.816 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:01:34.052 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:02:04.308 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:02:34.572 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:03:04.995 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:03:35.237 | INFO     | __main__:get_policy:177 - Job status IN_PROGRESS
    2022-02-21 13:04:05.636 | INFO     | __main__:get_policy:177 - Job status SUCCEEDED
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "SupportedServiceSid0",
                "Effect": "Allow",
                "Action": [
                    "cloudtrail:DescribeTrails",
                    "cloudtrail:LookupEvents",
                    "cloudwatch:DescribeAnomalyDetectors",
                    "cloudwatch:DescribeInsightRules",
                    "cloudwatch:ListDashboards",
                    "cloudwatch:PutAnomalyDetector",
                    "ec2:CreateTags",
                    "ec2:DeleteKeyPair",
                    "ec2:DeleteTags",
                    "ec2:DescribeAccountAttributes",
                    "ec2:DescribeAddresses",
                    "ec2:DescribeAvailabilityZones",
                    "ec2:DescribeClassicLinkInstances",
                    "ec2:DescribeDhcpOptions",
                    "ec2:DescribeHosts",
                    "ec2:DescribeImages",
                    "ec2:DescribeInstanceAttribute",
                    "ec2:DescribeInstanceCreditSpecifications",
                    "ec2:DescribeInstanceStatus",
                    "ec2:DescribeInstanceTypes",
                    "ec2:DescribeInstances",
                    "ec2:DescribeInternetGateways",
                    "ec2:DescribeKeyPairs",
                    "ec2:DescribeLaunchTemplates",
                    "ec2:DescribeManagedPrefixLists",
                    "ec2:DescribeNetworkAcls",
                    "ec2:DescribeNetworkInterfaces",
                    "ec2:DescribePlacementGroups",
                    "ec2:DescribeRegions",
                    "ec2:DescribeReplaceRootVolumeTasks",
                    "ec2:DescribeRouteTables",
                    "ec2:DescribeSecurityGroupRules",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeTags",
                    "ec2:DescribeTrafficMirrorTargets",
                    "ec2:DescribeVolumeAttribute",
                    "ec2:DescribeVolumeStatus",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeVolumesModifications",
                    "ec2:DescribeVpcAttribute",
                    "ec2:DescribeVpcEndpointServiceConfigurations",
                    "ec2:DescribeVpcs",
                    "ec2:GetSerialConsoleAccessStatus",
                    "elasticloadbalancing:CreateListener",
                    "elasticloadbalancing:CreateLoadBalancer",
                    "elasticloadbalancing:DescribeAccountLimits",
                    "elasticloadbalancing:DescribeListeners",
                    "elasticloadbalancing:DescribeLoadBalancerAttributes",
                    "elasticloadbalancing:DescribeLoadBalancers",
                    "elasticloadbalancing:DescribeSSLPolicies",
                    "elasticloadbalancing:DescribeTargetGroupAttributes",
                    "elasticloadbalancing:DescribeTargetGroups",
                    "elasticloadbalancing:DescribeTargetHealth",
                    "kafka:ListClusters",
                    "kafka:ListClustersV2",
                    "kms:ListAliases",
                    "logs:DescribeQueryDefinitions",
                    "resource-groups:ListGroups",
                    "s3:GetAccountPublicAccessBlock",
                    "s3:ListAccessPoints",
                    "s3:ListAllMyBuckets",
                    "s3:ListMultiRegionAccessPoints",
                    "secretsmanager:ListSecrets",
                    "ssm:DescribeInstanceInformation",
                    "sts:GetCallerIdentity",
                    "tag:GetResources"
                ],
                "Resource": "*"
            },
            {
                "Sid": "SupportedServiceSid1",
                "Effect": "Allow",
                "Action": [
                    "cloudtrail:GetEventSelectors",
                    "cloudtrail:GetTrailStatus"
                ],
                "Resource": "arn:aws:cloudtrail:${Region}:${Account}:trail/${TrailName}"
            },
            {
                "Sid": "SupportedServiceSid2",
                "Effect": "Allow",
                "Action": "cloudwatch:DescribeAlarms",
                "Resource": "arn:aws:cloudwatch:${Region}:${Account}:alarm:${AlarmName}"
            },
            {
                "Sid": "SupportedServiceSid3",
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:GetDashboard",
                    "cloudwatch:PutDashboard"
                ],
                "Resource": "arn:aws:cloudwatch::${Account}:dashboard/${DashboardName}"
            },
            {
                "Sid": "SupportedServiceSid4",
                "Effect": "Allow",
                "Action": [
                    "ec2:AttachVolume",
                    "ec2:ModifyInstanceAttribute",
                    "ec2:RunInstances",
                    "ec2:StartInstances",
                    "ec2:StopInstances",
                    "ec2:TerminateInstances"
                ],
                "Resource": "arn:aws:ec2:${Region}:${Account}:instance/${InstanceId}"
            },
            {
                "Sid": "SupportedServiceSid5",
                "Effect": "Allow",
                "Action": [
                    "ec2:CreateKeyPair",
                    "ec2:ImportKeyPair"
                ],
                "Resource": "arn:aws:ec2:${Region}:${Account}:key-pair/${KeyPairName}"
            },
            {
                "Sid": "SupportedServiceSid6",
                "Effect": "Allow",
                "Action": "ec2:RunInstances",
                "Resource": "arn:aws:ec2:${Region}:${Account}:network-interface/${NetworkInterfaceId}"
            },
            {
                "Sid": "SupportedServiceSid7",
                "Effect": "Allow",
                "Action": [
                    "ec2:AuthorizeSecurityGroupEgress",
                    "ec2:AuthorizeSecurityGroupIngress",
                    "ec2:CreateSecurityGroup",
                    "ec2:DeleteSecurityGroup",
                    "ec2:RevokeSecurityGroupEgress",
                    "ec2:RevokeSecurityGroupIngress",
                    "ec2:RunInstances"
                ],
                "Resource": "arn:aws:ec2:${Region}:${Account}:security-group/${SecurityGroupId}"
            },
            {
                "Sid": "SupportedServiceSid8",
                "Effect": "Allow",
                "Action": "ec2:RunInstances",
                "Resource": "arn:aws:ec2:${Region}:${Account}:subnet/${SubnetId}"
            },
            {
                "Sid": "SupportedServiceSid9",
                "Effect": "Allow",
                "Action": [
                    "ec2:AttachVolume",
                    "ec2:CreateVolume",
                    "ec2:DeleteVolume",
                    "ec2:DetachVolume",
                    "ec2:ModifyVolume",
                    "ec2:RunInstances"
                ],
                "Resource": "arn:aws:ec2:${Region}:${Account}:volume/${VolumeId}"
            },
            {
                "Sid": "SupportedServiceSid10",
                "Effect": "Allow",
                "Action": "ec2:RunInstances",
                "Resource": "arn:aws:ec2:${Region}::image/${ImageId}"
            },
            {
                "Sid": "SupportedServiceSid11",
                "Effect": "Allow",
                "Action": [
                    "elasticloadbalancing:DeleteListener",
                    "elasticloadbalancing:ModifyListener"
                ],
                "Resource": "arn:aws:elasticloadbalancing:${Region}:${Account}:listener/app/${LoadBalancerName}/${LoadBalancerId}/${ListenerId}"
            },
            {
                "Sid": "SupportedServiceSid12",
                "Effect": "Allow",
                "Action": [
                    "elasticloadbalancing:DeleteListener",
                    "elasticloadbalancing:ModifyListener"
                ],
                "Resource": "arn:aws:elasticloadbalancing:${Region}:${Account}:listener/net/${LoadBalancerName}/${LoadBalancerId}/${ListenerId}"
            },
            {
                "Sid": "SupportedServiceSid13",
                "Effect": "Allow",
                "Action": [
                    "elasticloadbalancing:AddTags",
                    "elasticloadbalancing:DeleteLoadBalancer",
                    "elasticloadbalancing:DescribeTags",
                    "elasticloadbalancing:ModifyLoadBalancerAttributes"
                ],
                "Resource": "arn:aws:elasticloadbalancing:${Region}:${Account}:loadbalancer/${LoadBalancerName}"
            },
            {
                "Sid": "SupportedServiceSid14",
                "Effect": "Allow",
                "Action": [
                    "elasticloadbalancing:CreateTargetGroup",
                    "elasticloadbalancing:DeleteTargetGroup",
                    "elasticloadbalancing:DeregisterTargets",
                    "elasticloadbalancing:ModifyTargetGroup",
                    "elasticloadbalancing:ModifyTargetGroupAttributes",
                    "elasticloadbalancing:RegisterTargets"
                ],
                "Resource": "arn:aws:elasticloadbalancing:${Region}:${Account}:targetgroup/${TargetGroupName}/${TargetGroupId}"
            },
            {
                "Sid": "SupportedServiceSid15",
                "Effect": "Allow",
                "Action": [
                    "logs:DescribeLogGroups",
                    "logs:DescribeLogStreams",
                    "logs:DescribeMetricFilters"
                ],
                "Resource": "arn:aws:logs:${Region}:${Account}:log-group:${LogGroupName}"
            }
        ]
    }
