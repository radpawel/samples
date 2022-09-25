variable "aws_region" {
  description = "In which region to create the instances"
}

# Product
variable "name" {
  description = "Name of the product"
  type        = string
}
variable "owner" {
  description = "Owner of the product"
  type        = string
}
variable "description" {
  description = "Description of the product."
  type        = string
}
variable "artifact_parameters" {
  description = "Configuration block for provisioning artifact (i.e., version) parameters"
  type        = list(map(string))
}

## VERSIONS
variable "templates" {
  description = "CF teamplate version details"
  type        = map(map(string))
  default     = {}
}