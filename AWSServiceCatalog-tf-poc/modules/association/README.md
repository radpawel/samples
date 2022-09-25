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
| [aws_servicecatalog_product_portfolio_association.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association) | resource |
| [aws_servicecatalog_product_portfolio_association.prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association) | resource |
| [aws_servicecatalog_product_portfolio_association.stable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_portfolio"></a> [dev\_portfolio](#input\_dev\_portfolio) | Portfolio identifier | `any` | n/a | yes |
| <a name="input_prod_portfolio"></a> [prod\_portfolio](#input\_prod\_portfolio) | Portfolio identifier | `any` | n/a | yes |
| <a name="input_product_name_id"></a> [product\_name\_id](#input\_product\_name\_id) | Map of product name and product id | `map(string)` | n/a | yes |
| <a name="input_products"></a> [products](#input\_products) | Configuration block for provisioning artifact (i.e., version) parameters | <pre>map(object({<br>    stage       = string<br>    name        = string<br>    owner       = string<br>    description = string<br>    params      = list(map(string))<br>    templates   = map(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_stable_portfolio"></a> [stable\_portfolio](#input\_stable\_portfolio) | Portfolio identifier | `any` | n/a | yes |

## Outputs

No outputs.
