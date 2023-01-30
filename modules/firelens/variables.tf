variable "namespace" {
  type = string
}

variable "container_registry" {
  type        = string
  description = "URL to the container registry for the logging image"

  # See https://github.com/wellcomecollection/platform-infrastructure/tree/main/images
  default = "760097843905.dkr.ecr.eu-west-1.amazonaws.com/uk.ac.wellcome"
}

variable "container_name" {
  type    = string
  default = "fluentbit"
}

variable "container_tag" {
  type    = string
  default = "ac9e48d11d76f3d3abd64e4a9440462539da2e7a"
}

variable "use_privatelink_endpoint" {
  description = "Should we send logs to Elasticsearch using the PrivateLink endpoint?  This must be accompanied by the appropriate security group."
  type        = bool
  default     = false
}

variable "essential" {
  description = "Is the logging container essential?"
  type        = bool
  default     = false
}
