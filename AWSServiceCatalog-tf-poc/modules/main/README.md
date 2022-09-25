## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>3.62.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_conveyor_portfolio"></a> [conveyor\_portfolio](#module\_conveyor\_portfolio) | ../sc_portfolio | n/a |
| <a name="module_conveyor_product"></a> [conveyor\_product](#module\_conveyor\_product) | ../sc_product | n/a |
| <a name="module_conveyor_product_association"></a> [conveyor\_product\_association](#module\_conveyor\_product\_association) | ../association | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_conveyor_portfolios"></a> [conveyor\_portfolios](#input\_conveyor\_portfolios) | Map containing portfolio details | `map(map(any))` | n/a | yes |
| <a name="input_conveyor_products"></a> [conveyor\_products](#input\_conveyor\_products) | Map defining product configuration | <pre>map(object({<br>    stage       = string<br>    name        = string<br>    owner       = string<br>    description = string<br>    params      = list(map(string))<br>    templates   = map(map(string))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_portfolios"></a> [portfolios](#output\_portfolios) | n/a |
| <a name="output_product_id"></a> [product\_id](#output\_product\_id) | n/a |
| <a name="output_product_info"></a> [product\_info](#output\_product\_info) | n/a |
