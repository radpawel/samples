remote_state {
  backend = "s3"


  config = {
    region         = "eu-west-1"
    bucket         = "django-test-state-${get_aws_account_id()}"
    dynamodb_table = "django-test-lock-table-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    s3_bucket_tags = {
      Service = "TestingDjango"
      Owner   = "pradko"
    }
    dynamodb_table_tags = {
      Service = "TestingDjango"
      Owner   = "pradko"
    }
  }
}
#
terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

  }

  extra_arguments "warning_summarize" {
    commands = [
      "plan",
      "apply",
      "destroy"
    ]

    arguments = ["-compact-warnings"]
  }

  extra_arguments "destroy_auto_approval" {
    commands = [
      "destroy"
    ]

    arguments = ["-auto-approve"]
  }

#  after_hook "after_hook_plan" {
#    commands = ["plan"]
#    execute  = ["sh", "-c", "terraform show -json plan.output > plan.json"]
#  }
}
