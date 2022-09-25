output "portfolios" {
  value = { for k in keys(var.conveyor_portfolios) : k => module.conveyor_portfolio[k].this_portfolio }
}
output "product_id" {
  value = { for k in keys(var.conveyor_products) : k => module.conveyor_product[k].product_ids.id }
}
output "product_info" {
  value = { for k in keys(var.conveyor_products) : k => module.conveyor_product[k] }
}
