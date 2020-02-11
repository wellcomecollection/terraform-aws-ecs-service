module "task_definition_single_container_awslogs" {
  source = "../task_definition/single_container"

  container_image = "tutum/hello-world"
  mount_points    = []

  aws_region = "eu-west-1"
  task_name  = "single_container_awslogs"

  use_awslogs = true
}

module "task_definition_single_container_nologs" {
  source = "../task_definition/single_container"

  container_image = "tutum/hello-world"
  mount_points    = []

  aws_region = "eu-west-1"
  task_name  = "single_container_nologs"

  use_awslogs = false
}

module "task_definition_container_with_sidecar_awslogs" {
  source = "../task_definition/container_with_sidecar"

  aws_region = "eu-west-1"
  task_name  = "container_with_sidecar_awslogs"

  app_container_image = "tutum/hello-world"

  app_container_port = 80
  app_cpu = "256"
  app_memory = "512"
  app_mount_points = []

  sidecar_container_image = "tutum/hello-world"

  sidecar_container_port = 8080
  sidecar_cpu = "256"
  sidecar_memory = "512"
  sidecar_mount_points = []

  cpu = "512"
  memory = "1024"

  use_awslogs = true
}

module "task_definition_container_with_sidecar_nologs" {
  source = "../task_definition/container_with_sidecar"

  aws_region = "eu-west-1"
  task_name  = "container_with_sidecar_nologs"

  app_container_image = "tutum/hello-world"

  app_container_port = 80
  app_cpu = "256"
  app_memory = "512"
  app_mount_points = []

  sidecar_container_image = "tutum/hello-world"

  sidecar_container_port = 8080
  sidecar_cpu = "256"
  sidecar_memory = "512"
  sidecar_mount_points = []

  cpu = "512"
  memory = "1024"

  use_awslogs = false
}