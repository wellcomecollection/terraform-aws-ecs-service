# CHANGELOG

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
