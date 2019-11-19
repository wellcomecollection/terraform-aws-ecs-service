variable "secret_env_vars" {
  description = "Secure environment variables to pass to the container"
  type        = map(string)
}

variable "execution_role_name" {}
