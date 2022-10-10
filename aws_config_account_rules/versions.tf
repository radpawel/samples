variable "aws_region" {
  description = "Which AWS region the instance is in"
  type        = string
}

provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.3.0"
    }
  }
  required_version = ">= 0.12"
}
