# CHANGELOG

## v3.11.1 - 2021-09-17

Make the logging container non-essential to prevent deployment issues where logging container cannot start (e.g. unavailable secrets)

## v3.11.0 - 2021-09-17

This change adds deployment circuit breaker configuration to our ECS module and enables it by default.

Enabling the "deployment circuit breaker", turns on detection of repeated failed attempts to start tasks as part of an ECS deployment and will "cancel" a deployment if a particular threshold for failed tasks is met.

## v3.9.4 - 2021-08-02

Only retain CloudWatch logs for the log router for 7 days, rather than forever.

This affects the `firelens` module.

## v3.9.3 - 2021-07-14

Same as the previous release, but now actually using the region.

## v3.9.2 - 2021-07-14

Use the provider region for the CloudWatch Logs group in the `firelens` module, rather than requiring eu-west-1.

## v3.9.1 - 2021-07-05

This fixes two bugs:

-   You couldn't create an ECS task that read secrets from Secrets Manager if the secrets didn't exist yet (e.g. if they were being created as part of the same Terraform configuration).

    Now you can configure secrets that don't exist yet as long as you're not looking up a specific key within that secret.

-   Fix a bug where service namespace discovery wasn't being enabled/disabled correctly.

## v3.9.0 - 2021-07-02

Add a boolean `enable_service_discovery` variable to the `service` module.

This allows callers to confirm that they're definitely going to use service discovery, and prevent an error like:

> The "for_each" value depends on resource attributes that cannot be
> determined until apply, so Terraform cannot predict how many instances
> will be created. To work around this, use the -target argument to first
> apply only the resources that the for_each depends on.

## v3.8.0 - 2021-07-01

You can now set the `container_registry` and `container_name` in the `nginx/apigw` module, e.g. if you want to pull your fluentbit container from our ECR Public repo (<https://gallery.ecr.aws/l7a1d1z4/nginx_apigw>).

## v3.7.0 - 2021-07-01

You can now set the `container_registry` and `container_name` in the `firelens` module, e.g. if you want to pull your fluentbit container from our ECR Public repo (<https://gallery.ecr.aws/l7a1d1z4/fluentbit>).

## v3.6.0 - 2021-05-21

This change means that we access/reference secrets directly in Secrets Manager, rather than by using the Parameter Store integration.

Whilst this is more verbose, it means that consumers can directly reference specific keys within secrets that are JSON objects - as this is a feature of Secrets Manager, not parameter store.

## v3.5.2 - 2021-04-20

Fix a bug in the firelens module in v3.5.1.

## v3.5.1 - 2021-04-20

Fix a bug in the firelens module in v3.5.0.

## v3.5.0 - 2021-04-20

The CloudWatch log group is now created (and deleted) by the Terraform module, rather than created on-the-fly by the services.
This means old log groups will get cleaned up when you delete a service, rather than hanging around forever.

## v3.4.0 - 2021-03-11

This adds a variable `use_privatelink_endpoint` to the `firelens` module, which causes logs to be sent via the PrivateLink endpoint instead of over the public Internet/NAT Gateway.

This must be accompanied by an appropriate security group.

## v3.3.1 - 2020-12-02

Remove an IAM role that we're not using in the `service` module.
The role isn't used anywhere, and not published as a module output for callers to use.

## v3.3.0 - 2020-10-08

Remove deployment label from tags - this functionality does not work!

Consumers will need to upgrade their AWS provider (post 2.60.0), and use `ignore_tags`.

See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging

## v3.2.2 - 2020-09-24

Bump for release.

## v3.2.1 - 2020-09-24

Bump for release

## v3.2.2 - 2020-09-24

Bump for release

## v3.2.1 - 2020-09-24

Bump for release

## v3.2.0 - 2020-09-21

Offers dedicated tags for:
- "deployment:env"
- "deployment:service"
- "deployment:label"

Changes to "deployment:label" are ignored, allowing it to be safely updated outside of terraform.

## v3.1.0 - 2020-08-03

- Add a module for a [cluster capacity provider backed by an Auto Scaling Group](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/asg-capacity-providers.html) for EC2 services.
- Make the service module able to use this capacity provider

## v3.0.0 - 2020-07-03

Simplifies volume mounting, and provides efs/fargate compatibility to task definitions.

In a task definition module:

```tf
// EC2 Host volume mounts
volumes = [{
  name = "ebs_volume"
  host_path = "/mnt/ebs"
},{
  name = "efs_volume"
  host_path = "/mnt/efs"
}]

// Specify your own placement constraints
placement_constraints = [{
  type       = "memberOf"
  expression = "attribute:efs.volume exists"
},{
  type       = "memberOf"
  expression = "attribute:ebs.volume exists"
}]


// Fargate EFS config
efs_volumes = [{
  name = local.efs_volume_name
  file_system_id = aws_efs_file_system.efs_fs.id
  root_directory = "/"
}]
```

## v2.6.3 - 2020-06-29

Remove dependency on remote state for firelens module

## v2.6.2 - 2020-06-25

Fix for container port in frontend module config - the nginx config dictates port 80 must be exposed as the container port

## v2.6.1 - 2020-06-23

Adds an nginx module for the experience apps

## v2.6.0 - 2020-06-01

- Add `system_controls` property to container definitions to allow setting kernel parameters in tasks

## v2.5.0 - 2020-06-01

- Add an "extra_volumes" field for specifying arbitrary volumes on the task definition.
  This is useful if you want non-persistent volumes shared between containers.

## v2.4.1 - 2020-04-29

Bump the default firelens container to one that uses `_doc` as the Elasticsearch document type.

See <https://github.com/wellcomecollection/platform-infrastructure/pull/17>

## v2.4.0 - 2020-04-28

Updates modules/firelens & modules/nginx/apigw.
- Use ECR image for fluentbit (firelens) container
- Paramaterise image tag so clients can upgrade selectively

## v2.3.0 - 2020-04-28

Adds default nginx image template to modules/nginx/apigw

Example usage: 

```
module "nginx_container" {
  source = "git::github.com/wellcomecollection/terraform-aws-ecs-service.git//modules/nginx/apigw"

  forward_port      = var.container_port
  log_configuration = module.log_router_container.container_log_configuration
}
```

## v2.2.1 - 2020-04-27

Provide a pre-packed debug config to feed app container logs to cloudwatch in modules/firelens (output is debug_container_log_configuration).

## v2.2.0 - 2020-04-27

Removes a data block referring to an IAM role in modules/secrets as this causes dependency issues in consumers.

Also renames the variable task_execution_role_name to role_name in modules/secrets to be clearer. Consumers will need to update their references accordingly.

## v2.1.0 - 2020-04-24

Provide `shared_secrets_logging` from modules/firelens as we have it here, so consumer does not need to look it up with remote data source (and provide single source of truth)
    Default `launch_types` to `["FARGATE"]` in modules/task_definition in order to simplify client config for the most common use case.

## v2.0.0 - 2020-04-24

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

## v1.7.0 - 2020-04-07

task_definition/container_with_sidecar:

    - Add optional healthcheck for app and allow sidecar to depend on it

## v1.6.0 - 2020-04-07

task_definition/container_with_sidecar:

- Make app container name configurable
- Make container port mappings for both containers optional

## v1.5.2 - 2020-03-23

task_definition/container_with_sidecar:

*   Fix a bug introduced in v1.5.0 that would lead to an error when trying to plan:

    > task_definition.tf line 51: An argument definition must end with a newline.

## v1.5.1 - 2020-03-23

task_definition/single_container:

*   The `container_port` variable added in v1.5.0 is optional, not required.

## v1.5.0 - 2020-03-11

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added variables `efs_volume_name` and `efs_host_path`.  If you use these, the module will create a task definition with this volume/host path mapping, and the `attribute:efs.volume exists` placement constraint.

task_definition/single_container:

*   Added variable `container_port` and `container_name` if you want to expose a port inside your container to a load balancer or similar.

## v1.4.0 - 2020-03-05

service:

*   Added variable `use_fargate_spot` to use Fargate Spot as the capacity provider for your tasks.
    This will switch *all* tasks in this service to use Fargate Spot -- it's an on-off switch, not a split of tasks between Spot/non-Spot instances.

    Only enable this flag for services with tasks that can be interrupted safely.

    See <https://aws.amazon.com/blogs/aws/aws-fargate-spot-now-generally-available/> for more details.

    It defaults to `false` to avoid breaking changes in existing services.

## v1.3.0 - 2020-02-18

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added variables `ebs_volume_name` and `ebs_host_path`.  If you use these, the module will create a task definition with this volume/host path mapping, and the `attribute:ebs.volume exists` placement constraint.
*   Fix a bug where `mount_points` couldn't be specified correctly.

service/:

*   If you created a service which connected to a load balancer, the internal name of the service will have changed.  You need to use `terraform state mv` to select the new name.

## v1.2.0 - 2020-02-11

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added a `use_awslogs` variable which includes the `loggingConfiguration` block from previous versions if `true`. Defaults to `false`, omitting all logging config.

## v1.1.1 - 2019-11-28

task_definition/modules/env_vars:

*   A small change to the way the JSON string passed to ECS is constructed.
    In particular, environment variable definitions should now have a stable
    sort order, and not change order between plans.

## v1.1.0 - 2019-11-25

autoscaling module:

*   This is a new module, meant to replace a module from the old terraform-modules repo.

service, task_definition modules:

*   Tweaks to type constraints in variables so they don't emit a deprecation warning
    from Terraform.  There should be no user visible change.

## v1.0.2 - 2019-11-19

Fix a deprecation warning with some type constraints on variables (e.g. using
`map(string)` instead of `"map"`).

This should improve error reporting if you've passed a variable that doesn't match
the type contraints.

## v1.0.1 - 2019-11-11

When using the `service` module, changes to `desired_count` (how many instances of the service to run) are ignored using Terraform's [ignore_changes feature](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).

This means that if the size of a service is changed outside Terraform (for example, by autoscaling), Terraform will not try to resize the service when you re-plan.

## v1.0.0 - 2019-11-11

Initial major release -- this is the v1.0 being used in the storage-service.

## v0.1.0 - 2019-11-11

Initial tagged version.
