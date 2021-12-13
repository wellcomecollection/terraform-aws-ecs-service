variable "forward_port" {
  type = number
}

variable "memory_reservation" {
  type    = number
  default = 50
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

variable "container_tag" {
  type    = string
  default = "28e3e1b1cd4e8ad69ff44f28757eedff9c99a661"
}

variable "image_name" {
  type    = string
  default = "uk.ac.wellcome/nginx_experience"
}
