resource "aws_servicecatalog_portfolio" "portfolio" {
  name          = var.name
  description   = var.description
  provider_name = var.provider_name
  tags          = var.tags
}

data "aws_servicecatalog_portfolio" "this" {
  id = aws_servicecatalog_portfolio.portfolio.id
}
