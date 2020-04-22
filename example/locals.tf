locals {
  namespace = "terraform-aws-ecs-service-example"

  vpc_id = data.terraform_remote_state.infra_shared.outputs.developer_vpc_id
  private_subnets = data.terraform_remote_state.infra_shared.outputs.developer_vpc_private_subnets

  shared_secrets_logging = data.terraform_remote_state.infra_shared.outputs.shared_secrets_logging
}