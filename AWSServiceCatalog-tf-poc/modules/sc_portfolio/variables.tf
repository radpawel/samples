// this var is defined in your envs/<env>/<region> directory
// To make it usable in your module you need to define an input variable
variable "aws_region" {
  description = "In which region to create the instances"
}
variable "name" {
  description = "The name of the portfolio."
}
variable "description" {
  description = "Description of the portfolio"
}
variable "provider_name" {
  description = "Name of the person or organization who owns the portfolio."
}
variable "tags" {
  description = <<-EOT
        Tags to apply to the connection. If configured with a provider default_tags configuration block present,
        tags with matching keys will overwrite those defined at the provider-level.
  EOT
  type        = map(string)
}
