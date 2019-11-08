variable "task_name" {}

variable "task_port" {
  default = "false"
}

variable "container_image" {}

variable "cpu" {
  default = 512
}

variable "memory" {
  default = 1024
}

variable "mount_points" {
  type    = "list"
  default = []
}

variable "command" {
  type    = "list"
  default = []
}

variable "env_vars" {
  description = "Environment variables to pass to the container"
  type        = "map"
  default     = {}
}

variable "secret_env_vars" {
  description = "Secure environment variables to pass to the container"
  type        = "map"
  default     = {}
}

variable "user" {
  default = "root"
}

variable "launch_type" {
  default = "FARGATE"
}

variable "aws_region" {}
