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

variable "container_registry" {
  type        = string
  description = "URL to the container registry for the nginx image"

  # See https://github.com/wellcomecollection/platform-infrastructure/tree/main/images/nginx
  default = "760097843905.dkr.ecr.eu-west-1.amazonaws.com/uk.ac.wellcome"
}

variable "container_name" {
  type    = string
  default = "nginx_apigw"
}

variable "container_tag" {
  type    = string
  default = "f1188c2a7df01663dd96c99b26666085a4192167"
}
