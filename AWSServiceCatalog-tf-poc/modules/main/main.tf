module "conveyor_portfolio" {
  for_each      = var.conveyor_portfolios ## What is going on here :)
  source        = "../sc_portfolio"
  name          = var.conveyor_portfolios[each.key].name ## complete
  description   = var.conveyor_portfolios ##complete
  provider_name = "CloudCore - ${each.key}"
  tags          = var.conveyor_portfolios ## complete Add tags
  aws_region    = var.aws_region

}

module "conveyor_product" {
  for_each            = var.conveyor_products
  source              = "../sc_product"
  aws_region          = var.aws_region
  description         = var.conveyor_products[each.key]["description"]
  name                = var.conveyor_products[each.key]["name"]
  owner               = var.conveyor_products[each.key]["owner"]
  artifact_parameters = var.conveyor_products[each.key]["params"]
  templates           = var.conveyor_products[each.key]["templates"]
}

module "conveyor_product_association" {
  source           = "../association"
  dev_portfolio    = module.conveyor_portfolio["conveyor-dev"].this_portfolio.id
  stable_portfolio = module.conveyor_portfolio["conveyor-stable"].this_portfolio.id
  prod_portfolio   = module.conveyor_portfolio["conveyor-prod"].this_portfolio.id
  product_name_id  = { for k in keys(var.conveyor_products) : k => module.conveyor_product[k].product_ids.id }
  products         = var.conveyor_products
}
