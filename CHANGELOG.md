# CHANGELOG

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
