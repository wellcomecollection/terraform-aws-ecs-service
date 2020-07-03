locals {
  namespace = "terraform-aws-ecs-service-example"

  efs_volume_name = "efs_fs"

  vpc_id          = data.terraform_remote_state.infra_shared.outputs.developer_vpc_id
  private_subnets = data.terraform_remote_state.infra_shared.outputs.developer_vpc_private_subnets
  public_subnets = data.terraform_remote_state.infra_shared.outputs.developer_vpc_public_subnets

  container_Port = 80
  host_port      = 80

  shared_secrets_logging = data.terraform_remote_state.infra_shared.outputs.shared_secrets_logging
}

data "aws_vpc" "vpc" {
  id = local.vpc_id
}