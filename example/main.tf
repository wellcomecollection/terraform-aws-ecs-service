# Create container definitions

module "app_one_container_definition" {
  source = "../modules/container_definition"
  name = "app_one"

  image = "busybox"

  command = [
    "/bin/sh",
    "-c",
    "while true; do echo \"$CONTENT\" && sleep 5s; done"
  ]

  environment = {
    CONTENT = "one"
  }

  log_configuration = module.log_router_container.container_log_configuration
}

module "app_two_container_definition" {
  source = "../modules/container_definition"
  name = "app_two"

  image = "busybox"

  command = [
    "/bin/sh",
    "-c",
    "while true; do echo \"$CONTENT\" && sleep 5s; done"
  ]

  environment = {
    CONTENT = "two"
  }

  log_configuration = module.log_router_container.container_log_configuration
}

# We will use firelens logging (Wellcome specific setup)

module "log_router_container" {
  source    = "../modules/firelens"
  namespace = local.namespace
}

module "log_router_permissions" {
  source              = "../modules/secrets"
  secrets             = local.shared_secrets_logging
  execution_role_name = module.task_definition.task_execution_role_name
}

# Create task definition

module "task_definition" {
  source = "../modules/task_definition"

  cpu = 256
  memory = 512

  container_definitions = [
    module.log_router_container.container_definition,
    module.app_one_container_definition.container_definition,
    module.app_two_container_definition.container_definition
  ]

  launch_types = ["FARGATE"]
  task_name = local.namespace
}

# Create service

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