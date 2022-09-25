variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
}

variable "my_subnets" {
  type = list(string)
}
