variable "aws_region" {
  description = "AWS region"
  type        = string
}
variable "conveyor_portfolios" {
  description = "Map containing portfolio details"
  type        = map(map(any))
}
variable "conveyor_products" {
  description = "Map defining product configuration"
  type = map(object({
    stage       = string
    name        = string
    owner       = string
    description = string
    params      = list(map(string))
    templates   = map(map(string))
  }))
}
