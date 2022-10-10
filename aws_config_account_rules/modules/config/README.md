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
| [aws_config_config_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_rule"></a> [config\_rule](#input\_config\_rule) | Configs for AWS Config managed rules | <pre>object({<br>    name             = string<br>    description      = string<br>    input_parameters = string<br>    source           = map(string)<br>    scope            = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_active"></a> [active](#input\_active) | Feature flag enabling resource | `bool` | `false` | no |

## Outputs

No outputs.
