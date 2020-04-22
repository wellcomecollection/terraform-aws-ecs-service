variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))

  default = []
}

variable "log_configuration" {
  type = object({
    logDriver = string
    options   = map(string)
    secretOptions = list(object({
      name      = string
      valueFrom = string
    }))
  })

  default = null
}

variable "firelens_configuration" {
  type = object({
    type    = string
    options = map(string)
  })

  default = null
}

variable "mount_points" {
  type = list(object({
    containerPath = string
    sourceVolume  = string
  }))

  default = null
}

variable "healthcheck" {
  type = object({
    command     = list(string)
    retries     = number
    timeout     = number
    interval    = number
    startPeriod = number
  })

  default     = null
}

variable "depends" {
  type = list(object({
    containerName = string
    condition     = string
  }))

  default = null
}

variable "user" {
  type    = string
  default = null
}

variable "secrets" {
  type = map(string)
  default = {}
}

variable "environment" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "essential" {
  type = bool
  default = true
}

variable "cpu" {
  type = number
  default = null
}

variable "memory" {
  type = number
  default = null
}

variable "memory_reservation" {
  type = number
  default = null
}

variable "image" {
  default = "busybox"
  type = string
}

variable "command" {
  default = null
  type = list(string)
}

variable "tags" {
  default = {}
  type = map(string)
}
