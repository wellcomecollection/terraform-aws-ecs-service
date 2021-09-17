variable "service_name" {}
variable "cluster_arn" {}

variable "propagate_tags" {
  type    = string
  default = "SERVICE"
}

variable "tags" {
  type    = map(string)
  default = {}
}

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
  type    = string
  default = null
}

variable "deployment_circuit_breaker" {
  type    = bool
  default = true
}

variable "deployment_circuit_breaker_rollback" {
  type    = bool
  default = false
}

variable "enable_service_discovery" {
  type    = bool
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "deployment_maximum_percent" {
  type    = number
  default = 200
}

variable "service_discovery_failure_threshold" {
  type    = number
  default = 1
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "container_name" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = string
  default = ""
}

variable "use_fargate_spot" {
  type    = bool
  default = false
}

variable "capacity_provider_strategies" {
  type = list(object({
    capacity_provider = string
    weight            = number
  }))
  default = []
}

variable "ordered_placement_strategies" {
  type = list(object({
    type  = string
    field = string
  }))
  default = []
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "deployment_env" {
  default = ""
}

variable "deployment_service" {
  default = ""
}
