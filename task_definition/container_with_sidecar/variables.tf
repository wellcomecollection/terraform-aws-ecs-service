variable "task_name" {}

variable "cpu" {}
variable "memory" {}

variable "use_awslogs" {
  type = bool
  default = false
}

# App

variable "app_container_image" {}
variable "app_container_port" {}
variable "app_cpu" {}
variable "app_memory" {}

variable "app_mount_points" {
  type    = list(map(string))
  default = []
}

variable "app_env_vars" {
  type    = map(string)
  default = {}
}

variable "secret_app_env_vars" {
  type    = map(string)
  default = {}
}

# Sidecar

variable "sidecar_container_image" {}
variable "sidecar_container_port" {}
variable "sidecar_cpu" {}
variable "sidecar_memory" {}

variable "sidecar_container_name" {
  default = "nginx"
}

variable "sidecar_mount_points" {
  type    = list(map(string))
  default = []
}

variable "sidecar_env_vars" {
  type    = map(string)
  default = {}
}

variable "secret_sidecar_env_vars" {
  type    = map(string)
  default = {}
}

variable "ebs_volume_name" {
  default = ""
}

variable "ebs_host_path" {
  default = ""
}

variable "app_user" {
  default = "root"
}

variable "sidecar_user" {
  default = "root"
}

variable "launch_type" {
  default = "FARGATE"
}

variable "aws_region" {}
