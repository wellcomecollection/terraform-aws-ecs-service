# ec2_capacity_provider

This module outputs the name of an [ECS Capacity Provider](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html) for attaching to a cluster and services within it.

As well as the capacity provider, it creates an auto scaling group and a launch template for the specified instance type and attaches the required IAM policies & roles.

If `assign_public_ips` is unset or false, then the VPC must contain either a NAT Gateway or VPC endpoints for the [required services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html).

### Example usage

```hcl
resource "aws_ecs_cluster" "cluster" {
  name               = "my_cluster_name"
  capacity_providers = [module.my_capacity_provider.name]
}

module "my_capacity_provider" {
  source = "ec2_capacity_provider"

  name = "my_capacity_provider"

  // Setting this variable from aws_ecs_cluster.cluster.name creates a cycle
  // The cluster name is required for the instance user data script
  // This is a known issue https://github.com/terraform-providers/terraform-provider-aws/issues/12739
  cluster_name = "my_cluster_name"

  instance_type           = "..."
  max_instances           = 123
  use_spot_purchasing     = true

  subnets = var.subnets
  security_group_ids = var.security_group_ids
}

module "my_ecs_service" "service" {
  source = "service"

  // ...

  capacity_provider_strategies = [{
    capacity_provider = module.my_capacity_provider.name
    weight            = 1
  }]

  // You MUST specify at least one placement strategy or the capacity provider
  // will silently refuse to place any tasks from this service.
  ordered_placement_strategies = [{
    type = "spread"
    field = "host"
  }]
}
```
