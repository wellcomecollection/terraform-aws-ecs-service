module "logging_secrets_permissions" {
  source = "../modules/secrets"

  execution_role_name = module.task_definition.task_execution_role_name

  secrets = local.shared_secrets_logging
}

# TODO:
# - Modularise log_router_container
# - ensure new containre defs don't cause churn

module "log_router_container" {
  source = "../modules/container_definition"
  image  = "wellcome/fluentbit:132"

  name = "log_router"

  memory_reservation = 50

  firelens_configuration = {
    type = "fluentbit"
    options = {
      "config-file-type" = "file"
      "config-file-value" = "/extra.conf"
    }
  }

  environment = {
    SERVICE_NAME = local.namespace
  }

  secrets = local.shared_secrets_logging

  log_configuration = {
    logDriver = "awslogs"

    options = {
      "awslogs-group" = local.namespace,
      "awslogs-region" = "eu-west-1",
      "awslogs-create-group" = "true",
      "awslogs-stream-prefix" = "log_router"
    }

    secretOptions = null
  }
}

module "app_container_definition" {
  source = "../modules/container_definition"
  name = "app"

  command = [
    "/bin/sh",
    "-c",
    "while true; do echo \"zzz\" && sleep 5s; done"
  ]

  log_configuration = {
    logDriver = "awsfirelens"
    options = {
      Name = "stdout"
      Match = "*",
    }

    secretOptions = null
  }
}

module "task_definition" {
  source = "../modules/task_definition"

  cpu = 256
  memory = 512

  container_definitions = [
    module.log_router_container.container_definition,
    module.app_container_definition.container_definition
  ]

  launch_types = ["FARGATE"]
  task_name = local.namespace
}

module "service" {
  source = "../modules/service"

  cluster_arn  = aws_ecs_cluster.cluster.arn
  service_name = local.namespace

  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

  task_definition_arn = module.task_definition.arn

  subnets = local.private_subnets
  security_group_ids = [aws_security_group.allow_full_egress.id]
}

resource "aws_security_group" "allow_full_egress" {
  name        = "full_egress"
  description = "Allow outbound traffic"
  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name = local.namespace
  vpc  = local.vpc_id
}

resource "aws_ecs_cluster" "cluster" {
  name = local.namespace
}