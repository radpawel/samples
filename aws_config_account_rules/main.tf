locals {
  rds_instance_backup_tag = "audit-rds-instance-backup-tags"
}

module "aws_managed_rule__audit_rds_instance_backup_tags" {
  source = "./modules/config"
  active = contains(var.aws_config_manged_rules_account_level, local.rds_instance_backup_tag)
  config_rule = {
    name        = local.rds_instance_backup_tag
    description = "Checks if resources have required tags"
    # Option to add up to 6 tag1Key & tag1Value in total
    input_parameters = jsonencode({ tag1Key = "Service", tag1Value = "daas_mysql,daas_postgres" })
    scope            = ["AWS::RDS::DBInstance"]
    source = {
      source_identifier = "REQUIRED_TAGS"
    }
  }
}

module "aws_sns_topic__audit_rds_instance_backup_tags" {
  source                = "git::https://github.groupondev.com/terraform-modules/aws-sns.git?ref=v0.4.0"
  create_sns_topic      = contains(var.aws_config_manged_rules_account_level, local.rds_instance_backup_tag)
  name                  = local.rds_instance_backup_tag
  policy_allow_services = ["events.amazonaws.com"]
  subscribers = {
    team1 = {
      protocol               = "email"
      endpoint               = "cloud-core@groupon.com"
      endpoint_auto_confirms = false
      raw_message_delivery   = false
    }
    team2 = {
      protocol               = "email"
      endpoint               = "production-backup@groupon.com"
      endpoint_auto_confirms = false
      raw_message_delivery   = false
    }
  }
}

module "event_bridge__audit_rds_instance_backup_tags" {
  source                     = "./modules/event_bridge"
  active                     = contains(var.aws_config_manged_rules_account_level, local.rds_instance_backup_tag)
  cloudwatch_event_rule_name = local.rds_instance_backup_tag
  description                = "Compliance Change Notification on RDS Instances missing backup tag"
  event_pattern = templatefile("${path.module}/event_patterns/${local.rds_instance_backup_tag}.json",
  { cloudwatch_event_rule_name = local.rds_instance_backup_tag })
  target_arn = module.aws_sns_topic__audit_rds_instance_backup_tags.sns_topic_arn
  target_input_transformer = {
    input_template = {
      awsAccountId = "$.detail.awsAccountId"
      awsRegion    = "$.detail.awsRegion"
      compliance   = "$.detail.newEvaluationResult.complianceType"
      resourceId   = "$.detail.resourceId"
      resourceType = "$.detail.resourceType"
      rule         = "$.detail.configRuleName"
      time         = "$.detail.newEvaluationResult.resultRecordedTime"
    }
    input_paths = "\"On <time> AWS Config rule <rule> evaluated the <resourceType> with Id <resourceId> in the account <awsAccountId> region <awsRegion> as <compliance> For more details open the AWS Config console at https://console.aws.amazon.com/config/home?region=<awsRegion>#/timeline/<resourceType>/<resourceId>/configuration\""
  }
}

