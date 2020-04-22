variable "service_name" {}
variable "cluster_arn" {}

variable "desired_task_count" {
  default = 1
}

variable "task_definition_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "service_discovery_namespace_id" {
  type = string
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "deployment_minimum_healthy_percent" {
  type = number
  default = 100
}

variable "deployment_maximum_percent" {
  type = number
  default = 200
}

variable "service_discovery_failure_threshold" {
  type = number
  default = 1
}

variable "launch_type" {
  type = string
  default = "FARGATE"
}

variable "target_group_arn" {
  type = string
  default = ""
}

variable "container_name" {
  type = string
  default = ""
}

variable "container_port" {
  type = string
  default = ""
}

variable "use_fargate_spot" {
  type    = bool
  default = false
}
