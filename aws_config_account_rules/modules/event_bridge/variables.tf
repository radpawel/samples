variable "active" {
  type        = bool
  default     = false
  description = "Feature flag enabling resource"
}

variable "cloudwatch_event_rule_name" {
  description = "(Optional) The description of the cloud watch event rule."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the rule."
  type        = string
}

variable "event_pattern" {
  description = <<-EOF
  (Optional) The event pattern described a JSON object. At least one of schedule_expression or event_pattern
  is required. See full documentation of Events and Event Patterns in EventBridge for details.
  EOF
  type        = string
}

variable "target_arn" {
  description = "(Required) The Amazon Resource Name (ARN) of the target."
  type        = string
}

variable "target_input_transformer" {
  description = <<-EOF
  (Optional) Parameters used when you are providing a custom input to a target based on certain event data.
  Conflicts with input and input_path.
  EOF

  type = object({
    input_template = map(string)
    input_paths    = string
  })
}

