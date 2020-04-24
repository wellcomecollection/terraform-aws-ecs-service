RELEASE_TYPE: major

    - Updates module layout
    - Adds container definition module
    - Adds firelens logging module (Wellcome specific)

All modules have been moved beneath the `modules` directory, with an example terraform stack demonstrating use in `example`.

This is a major change to how ECS task definitions are provided. To update you will need to create container definitions.

### Container definitions

**Previously** a task definition subsumed container definitions:

```hcl-terraform
module "task_definition_container_with_sidecar_nologs" {
  source = "../task_definition/container_with_sidecar"

  aws_region = "eu-west-1"
  task_name  = "container_with_sidecar"

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
}
```

**Now** container definitions require you to define them separately:

```hcl-terraform
module "app_one_container_definition" {
  source = "../modules/container_definition"
  name   = "app_one"
  image  = "busybox"
}

module "app_two_container_definition" {
  source = "../modules/container_definition"
  name   = "app_two"
  image  = "busybox"
}

module "task_definition" {
  source = "../modules/task_definition"

  cpu    = 256
  memory = 512

  container_definitions = [
    module.app_one_container_definition.container_definition,
    module.app_two_container_definition.container_definition
  ]

  launch_types = ["FARGATE"]
  task_name    = "task_name"
}
```

### Logging container

This change provides modules implementing the updated logging pattern described in https://github.com/wellcomecollection/docs/tree/master/rfcs/022-logging.

 In order to use the logging container you will need to ensure your account has the correct secrets provisioned (See https://github.com/wellcomecollection/platform-infrastructure/blob/master/shared/secrets.tf).
 
 To use the new logging pattern, you will need to create a log router container (a Wellcome specific fluentbit image) and provide it the correct permissions to access secrets (used to auth with Elasticsearch). 
 
 ```hcl-terraform
module "log_router_container" {
  source    = "../modules/firelens"
  namespace = local.namespace
}

module "log_router_permissions" {
  source              = "../modules/secrets"
  secrets             = local.shared_secrets_logging
  execution_role_name = module.task_definition.task_execution_role_name
}

module "app_container" {
  source = "../modules/container_definition"
  name   = "app"

  image = "busybox"

  #  Get config from the firelens module.
  log_configuration = module.log_router_container.container_log_configuration
}

module "task_definition" {
  source = "../modules/task_definition"

  cpu    = 256
  memory = 512

  container_definitions = [
    module.log_router_container.container_definition,
    module.app_container.container_definition
  ]

  launch_types = ["FARGATE"]
  task_name    = "task_name"
}
```
 
All other logging configuration is supported as per https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LogConfiguration.html.
