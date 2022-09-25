

locals {
  django_image = "YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/django-app"
  nginx_image  = "YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/nginx-app"

  my_subnets         = var.my_subnets
  tags = {
    Owner   = "django-team@google.com",
    Service = "django-app-base"
  }

  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}


resource "aws_security_group" "django-app-base" {
  name        = "django-app-base"
  description = "Allow inbound HTTP/HTTPS traffic to django service"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = "service-team@google.com"
    Service = "django"
  }
}
#
#
resource "aws_cloudwatch_log_group" "django_app_cluster" {
  name = "django-app-cluster"
}

resource "aws_ecs_cluster" "django_app_cluster" {
  name = "django-app"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.django_app_cluster.name
      }
    }
  }
}


resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.django_app_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}


## Task definition

resource "aws_ecs_task_definition" "service" {
  family                   = "django-app-base"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "nginx-django-app-base"
      image     = local.nginx_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    },
    {
      name      = "django-app-base"
      image     = local.django_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}


## Service
#
resource "aws_ecs_service" "django_service" {
  name            = "djangoservice"
  cluster         = aws_ecs_cluster.django_app_cluster.name
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  tags_all        = local.tags

  network_configuration {
    subnets          = local.my_subnets
    security_groups  = [aws_security_group.django-app-base.id]
    assign_public_ip = true
  }
}


## data

data "aws_ecs_cluster" "cluster_info" {
  cluster_name = aws_ecs_cluster.django_app_cluster.name

}


data "aws_ecs_service" "service_info" {
  service_name = aws_ecs_service.django_service.name
  cluster_arn  = data.aws_ecs_cluster.cluster_info.arn
}

data "aws_ecs_task_definition" "task_info" {
  task_definition = aws_ecs_task_definition.service.family
}

output "data" {
  value = [ data.aws_ecs_service.service_info, data.aws_ecs_task_definition.task_info, data.aws_ecs_cluster.cluster_info]
}