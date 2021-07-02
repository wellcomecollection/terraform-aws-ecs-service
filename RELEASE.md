RELEASE_TYPE: minor

Add a boolean `enable_service_discovery` variable to the `service` module.

This allows callers to confirm that they're definitely going to use service discovery, and prevent an error like:

> The "for_each" value depends on resource attributes that cannot be
> determined until apply, so Terraform cannot predict how many instances
> will be created. To work around this, use the -target argument to first
> apply only the resources that the for_each depends on.
