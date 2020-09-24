# Create container definitions

module "nginx_container_definition" {
  source = "../modules/container_definition"

  name  = "nginx"
  image = "nginx"

  port_mappings = [{
    containerPort = local.container_Port
    hostPort      = local.host_port
    protocol      = "tcp"
  }]

  mount_points = [{
    containerPath = "/usr/share/nginx/html"
    sourceVolume  = local.efs_volume_name
  }]

  log_configuration = module.log_router_container.container_log_configuration
}

module "app_container_definition" {
  source = "../modules/container_definition"
  name   = "app_two"

  image = "busybox"

  // This example works by writing to the EFS volume read by the nginx container
  command = [
    "/bin/sh",
    "-c",
    "while true; do echo \"$CONTENT $(date)\" > /efs_fs/index.html && sleep 5s; done"
  ]

  mount_points = [{
    containerPath = "/efs_fs"
    sourceVolume  = local.efs_volume_name
  }]

  environment = {
    CONTENT = "Hello @ "
  }

  log_configuration = module.log_router_container.container_log_configuration
}

# We will use firelens logging (Wellcome specific setup)

module "log_router_container" {
  source    = "../modules/firelens"
  namespace = local.namespace
}

module "log_router_permissions" {
  source    = "../modules/secrets"
  secrets   = local.shared_secrets_logging
  role_name = module.task_definition.task_execution_role_name
}

# Create task definition

module "task_definition" {
  source = "../modules/task_definition"

  cpu    = 256
  memory = 512

  container_definitions = [
    module.log_router_container.container_definition,
    module.nginx_container_definition.container_definition,
    module.app_container_definition.container_definition
  ]

  efs_volumes = [{
    name           = local.efs_volume_name
    file_system_id = aws_efs_file_system.efs_fs.id
    root_directory = "/"
  }]

  launch_types = ["FARGATE"]
  task_name    = local.namespace
}

# Create service

module "service" {
  source = "../modules/service"

  cluster_arn  = aws_ecs_cluster.cluster.arn
  service_name = local.namespace

  task_definition_arn = module.task_definition.arn

  target_group_arn = aws_alb_target_group.service.arn

  container_port = local.container_Port
  container_name = module.nginx_container_definition.name

  subnets = local.private_subnets
  security_group_ids = [
    aws_security_group.allow_full_egress.id,
    aws_security_group.interservice.id
  ]
}

resource "aws_ecs_cluster" "cluster" {
  name = local.namespace
}
