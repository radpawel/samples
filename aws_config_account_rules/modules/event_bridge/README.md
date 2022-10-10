## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_event_rule_name"></a> [cloudwatch\_event\_rule\_name](#input\_cloudwatch\_event\_rule\_name) | (Optional) The description of the cloud watch event rule. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the rule. | `string` | n/a | yes |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | (Optional) The event pattern described a JSON object. At least one of schedule\_expression or event\_pattern<br>is required. See full documentation of Events and Event Patterns in EventBridge for details. | `string` | n/a | yes |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | (Required) The Amazon Resource Name (ARN) of the target. | `string` | n/a | yes |
| <a name="input_target_input_transformer"></a> [target\_input\_transformer](#input\_target\_input\_transformer) | (Optional) Parameters used when you are providing a custom input to a target based on certain event data.<br>Conflicts with input and input\_path. | <pre>object({<br>    input_template = map(string)<br>    input_paths    = string<br>  })</pre> | n/a | yes |
| <a name="input_active"></a> [active](#input\_active) | Feature flag enabling resource | `bool` | `false` | no |

## Outputs

No outputs.
