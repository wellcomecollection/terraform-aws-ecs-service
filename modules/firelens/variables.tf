variable "namespace" {
  type = string
}

variable "container_tag" {
  type    = string
  default = "2ccd2c68f38aa77a8ac1a32fe3ea54bbbd397a38"
}

variable "use_privatelink_endpoint" {
  description = "Should we send logs to Elasticsearch using the PrivateLink endpoint?  This must be accompanied by the appropriate security group."
  type        = bool
  default     = false
}
