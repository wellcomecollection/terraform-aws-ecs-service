[
  {
    "essential": true,
    "name": "${sidecar_container_name}",
    "environment": ${sidecar_environment_vars},
    "secrets": ${sidecar_secret_environment_vars},
    "image": "${sidecar_container_image}",
    "memory": ${sidecar_memory},
    "cpu": ${sidecar_cpu},
    %{ if expose_sidecar_port }
    "portMappings": ${sidecar_port_mappings},
    %{ endif }
    "logConfiguration": {
        "logDriver":"awsfirelens",
        "options": {
            "Name": "cloudwatch",
            "region": "${log_group_region}",
            "log_group_name": "${sidecar_log_group_name}",
            "auto_create_group": "true",
            "log_stream_prefix": "${log_group_prefix}"
        }
    },
    %{ if sidecar_depends_on_app_condition != "" }
    "dependsOn": [
        {
            "containerName": "${app_container_name}",
            "condition": "${sidecar_depends_on_app_condition}"
        }
    ],
    %{ endif }
    "user": "${sidecar_user}",
    "mountPoints": ${sidecar_mount_points}
  },
  {
    "essential": true,
    "image": "${app_container_image}",
    "memory": ${app_memory},
    "cpu": ${app_cpu},
    "name": "${app_container_name}",
    "environment": ${app_environment_vars},
    "secrets": ${app_secret_environment_vars},
    %{ if expose_app_port }
    "portMappings": ${app_port_mappings},
    %{ endif }
    "logConfiguration": {
        "logDriver":"awsfirelens",
        "options": {
            "Name": "cloudwatch",
            "region": "${log_group_region}",
            "log_group_name": "${app_log_group_name}",
            "auto_create_group": "true",
            "log_stream_prefix": "${log_group_prefix}"
        }
    },
    %{ if app_healthcheck != "" }
    "healthCheck": ${app_healthcheck},
    %{ endif }
    "user": "${app_user}",
    "mountPoints": ${app_mount_points}
  },
  {
    "essential": true,
    "image": "wellcome/fluentbit",
    "name": "log_router",
    "environment": [
      {
        "name": "FLB_LOG_LEVEL",
        "value": "debug"
      },
      {
        "name": "SERVICE_NAME",
        "value": "${app_log_group_name}"
      }
    ],
    "secrets": [
      {
        "name": "ES_PASS",
        "valueFrom": "${secret_espass_arn}"
      },
      {
        "name": "ES_USER",
        "valueFrom": "${secret_esuser_arn}"
      },
      {
        "name": "ES_HOST",
        "valueFrom": "${secret_eshost_arn}"
      },
      {
        "name": "ES_PORT",
        "valueFrom": "${secret_esport_arn}"
      }
    ],
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "enable-ecs-log-metadata": true,
        "config-file-type": "file",
        "config-file-value": "/extra.conf"
      }
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "firelens-container",
        "awslogs-region": "eu-west-1",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "firelens"
      }
    }
  }
]
