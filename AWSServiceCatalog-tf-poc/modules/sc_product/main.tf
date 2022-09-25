resource "aws_servicecatalog_product" "this" {
  name        = var.name
  owner       = var.owner
  type        = "CLOUD_FORMATION_TEMPLATE"
  description = var.description
  distributor = "CloudCore"

  dynamic "provisioning_artifact_parameters" {
    for_each = var.artifact_parameters
    content {
      description  = provisioning_artifact_parameters.value.description
      name         = provisioning_artifact_parameters.value.name
      template_url = provisioning_artifact_parameters.value.template_url
      type         = "CLOUD_FORMATION_TEMPLATE"
    }
  }
  tags = {
    Name       = var.name
    ServiceTag = "aws-landing-zone"
    Owner      = "dev@groupon.com"
  }
  support_description = "Reach out on #aws-landing-zone for any issues"
}

resource "aws_servicecatalog_provisioning_artifact" "this" {
  for_each     = var.templates
  name         = each.value["version"]
  product_id   = aws_servicecatalog_product.this.id
  type         = "CLOUD_FORMATION_TEMPLATE"
  template_url = each.value["template"]
  description  = each.value["description"]
  guidance     = each.value["guidance"]
}

data "aws_servicecatalog_product" "this" {
  id = aws_servicecatalog_product.this.id
}
