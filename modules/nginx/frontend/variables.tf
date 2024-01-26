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

# Require the user to specify the container tag, so we can't accidentally
# deploy the wrong version of the container unintentionally.
variable "container_tag" {
  type    = string
  description = "See https://github.com/wellcomecollection/platform-infrastructure/tree/main/images/dockerfiles"
}

variable "image_name" {
  type    = string
  default = "uk.ac.wellcome/nginx_frontend"
}
