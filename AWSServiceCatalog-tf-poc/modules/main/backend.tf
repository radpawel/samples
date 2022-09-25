// Every¸Terraform module that is used with Terragrunt, needs this empty backend definition.
// The backend will be automatically configured by Terragerunt

terraform {
  backend "s3" {}
}
