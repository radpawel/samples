## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_managed_rule__audit_rds_instance_tags"></a> [aws\_managed\_rule\_\_audit\_rds\_instance\_tags](#module\_aws\_managed\_rule\_\_audit\_rds\_instance\_tags) | ./modules/config | n/a |
| <a name="module_aws_sns_topic"></a> [aws\_sns\_topic](#module\_aws\_sns\_topic) | ./modules/sns | n/a |
| <a name="module_event_bridge"></a> [event\_bridge](#module\_event\_bridge) | ./modules/event_bridge | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Which AWS region the instance is in | `string` | n/a | yes |
| <a name="input_active"></a> [active](#input\_active) | Feature flag enabling resource | `bool` | `false` | no |
| <a name="input_aws_config_manged_rules_account_level"></a> [aws\_config\_manged\_rules\_account\_level](#input\_aws\_config\_manged\_rules\_account\_level) | List of rules that are enabled in the account | `list(string)` | `[]` | no |

## Outputs

No outputs.
