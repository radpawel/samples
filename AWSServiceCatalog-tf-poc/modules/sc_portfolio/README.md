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
| [aws_servicecatalog_portfolio.portfolio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio) | resource |
| [aws_servicecatalog_portfolio.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicecatalog_portfolio) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | In which region to create the instances | `any` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the portfolio | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the portfolio. | `any` | n/a | yes |
| <a name="input_provider_name"></a> [provider\_name](#input\_provider\_name) | Name of the person or organization who owns the portfolio. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the connection. If configured with a provider default\_tags configuration block present,<br>tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_portfolio"></a> [this\_portfolio](#output\_this\_portfolio) | Provides information for a Service Catalog Portfolio. |
