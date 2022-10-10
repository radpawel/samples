resource "aws_cloudwatch_event_rule" "this" {
  count          = var.active ? 1 : 0
  name           = var.cloudwatch_event_rule_name
  event_bus_name = "default"
  description    = var.description
  event_pattern  = var.event_pattern
}

resource "aws_cloudwatch_event_target" "this" {
  count          = var.active ? 1 : 0
  arn            = var.target_arn
  rule           = aws_cloudwatch_event_rule.this[0].name
  event_bus_name = "default"

  dynamic "input_transformer" {
    for_each = var.target_input_transformer == null ? [] : [var.target_input_transformer]
    content {
      input_paths    = lookup(input_transformer.value, "input_template", null)
      input_template = input_transformer.value["input_paths"]
    }
  }
}



