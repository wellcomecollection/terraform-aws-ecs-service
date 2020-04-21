module "example" {
  source = "../container_definition"

  cpu = 0
  memory = 0
  name = "foop"

  secrets = {
    MY_SECRET = "my/secret/thing"
  }
}