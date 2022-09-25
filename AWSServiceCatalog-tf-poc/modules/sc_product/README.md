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
| [aws_servicecatalog_product.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product) | resource |
| [aws_servicecatalog_provisioning_artifact.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_provisioning_artifact) | resource |
| [aws_servicecatalog_product.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicecatalog_product) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_parameters"></a> [artifact\_parameters](#input\_artifact\_parameters) | Configuration block for provisioning artifact (i.e., version) parameters | `list(map(string))` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | In which region to create the instances | `any` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the product. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the product | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the product | `string` | n/a | yes |
| <a name="input_templates"></a> [templates](#input\_templates) | CF teamplate version details | `map(map(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_product_ids"></a> [product\_ids](#output\_product\_ids) | n/a |
