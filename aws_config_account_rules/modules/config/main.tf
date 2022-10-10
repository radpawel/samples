resource "aws_config_config_rule" "this" {
  count            = var.active ? 1 : 0
  name             = var.config_rule["name"]
  description      = var.config_rule["description"]
  input_parameters = var.config_rule["input_parameters"]
  source {
    owner             = "AWS"
    source_identifier = var.config_rule["source"]["source_identifier"]
  }
  scope {
    compliance_resource_types = var.config_rule["scope"]
  }
  #deal with dependency in terragrunt...
  #configuration recorder is created in other module
  #depends_on = [aws_config_configuration_recorder.foo]
}

