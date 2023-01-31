locals {
  container_log_configuration = {
    logDriver = "awsfirelens"
    options = {
      Name  = "null"
      Match = "*",
    }

    secretOptions = null
  }

  // This will feed an app container logs to stdout
  // Consequently those logs will appear in cloudwatch
  // alongside the log_router logs
  debug_container_log_configuration = {
    logDriver = "awsfirelens"
    options = {
      Name  = "stdout"
      Match = "*",
    }

    secretOptions = null
  }

  image = "${var.container_registry}/${var.container_name}:${var.container_tag}"

  // These secrets are assigned on a per account basis:
  // https://github.com/wellcomecollection/platform-infrastructure/blob/main/critical/secrets.tf
  // The secrets are copied between accounts to the same identifiers.
  // This results in secrets having the same SSM paths in every account,
  // although those paths refer to the secrets in that particular account.
  shared_secrets_logging = {
    ES_USER          = "shared/logging/es_user"
    ES_PASS          = "shared/logging/es_pass"
    ES_HOST          = var.use_privatelink_endpoint ? "shared/logging/es_host_private" : "shared/logging/es_host"
    ES_PORT          = "shared/logging/es_port"
    DATA_STREAM_NAME = "shared/logging/firelens_data_stream_name"
  }
}
