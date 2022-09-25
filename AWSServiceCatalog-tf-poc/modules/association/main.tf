## Assign product to a portfolio, usage a stage: dev,stable,prod
locals {
  # Filter products checking stage variable
  dev = {
    for k, v in var.product_name_id : k => v if var.products[k].stage == "dev"
  }
  stable = {
    for k, v in var.product_name_id : k => v if var.products[k].stage == "stable"
  }
  prod = {
    for k, v in var.product_name_id : k => v if var.products[k].stage == "prod"
  }
}

resource "aws_servicecatalog_product_portfolio_association" "dev" {
  for_each     = local.dev
  portfolio_id = var.dev_portfolio #module.conveyor["conveyor-dev"].this_portfolio.id
  product_id   = each.value
}

resource "aws_servicecatalog_product_portfolio_association" "stable" {
  for_each     = local.stable
  portfolio_id = var.stable_portfolio #module.conveyor["conveyor-stable"].this_portfolio.id
  product_id   = each.value
}

resource "aws_servicecatalog_product_portfolio_association" "prod" {
  for_each     = local.prod
  portfolio_id = var.prod_portfolio #module.conveyor["conveyor-prod"].this_portfolio.id
  product_id   = each.value
}
