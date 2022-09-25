
locals {
  ecr_repos = {
    n = "nginx-app",
    d = "django-app"
  }
  tags = {
    Owner   = "django-team@google.com",
    Service = "django-app-base"
  }

  execution_role_arn = "arn:aws:iam::${var.aws_account_id}}:role/AWSServiceRoleForECS"
}


resource "aws_ecr_repository" "django_app_repo_name" {
  for_each = local.ecr_repos
  name     = each.value
  force_delete = true
  tags = local.tags
}
