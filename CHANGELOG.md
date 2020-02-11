# CHANGELOG

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
