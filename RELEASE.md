RELEASE_TYPE: minor

The CloudWatch log group is now created (and deleted) by the Terraform module, rather than created on-the-fly by the services.
This means old log groups will get cleaned up when you delete a service, rather than hanging around forever.