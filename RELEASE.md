RELEASE_TYPE: minor

Adds default nginx image template to modules/nginx/apigw

Example usage: 

```
module "nginx_container" {
  source = "git::github.com/wellcomecollection/terraform-aws-ecs-service.git//modules/nginx/apigw"

  forward_port      = var.container_port
  log_configuration = module.log_router_container.container_log_configuration
}
```
