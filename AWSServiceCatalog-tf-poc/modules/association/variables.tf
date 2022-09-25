variable "product_name_id" {
  description = "Map of product name and product id"
  type        = map(string)
}
variable "dev_portfolio" {
  description = "Portfolio identifier"
}
variable "stable_portfolio" {
  description = "Portfolio identifier"
}
variable "prod_portfolio" {
  description = "Portfolio identifier"
}
variable "products" {
  description = "Configuration block for provisioning artifact (i.e., version) parameters"
  type = map(object({
    stage       = string
    name        = string
    owner       = string
    description = string
    params      = list(map(string))
    templates   = map(map(string))
  }))
}
