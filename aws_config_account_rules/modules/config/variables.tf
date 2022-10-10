variable "config_rule" {
  description = "Configs for AWS Config managed rules"
  type = object({
    name             = string
    description      = string
    input_parameters = string
    source           = map(string)
    scope            = list(string)
  })
}

variable "active" {
  type        = bool
  default     = false
  description = "Feature flag enabling resource"
}

