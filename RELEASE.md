RELEASE_TYPE: patch

When using the `service` module, changes to `desired_count` (how many instances of the service to run) are ignored using Terraform's [ignore_changes feature](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).

This means that if the size of a service is changed outside Terraform (for example, by autoscaling), Terraform will not try to resize the service when you re-plan.