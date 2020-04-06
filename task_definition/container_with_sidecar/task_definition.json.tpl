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
    %{ if use_aws_logs }
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${sidecar_log_group_name}",
            "awslogs-region": "${log_group_region}",
            "awslogs-stream-prefix": "${log_group_prefix}"
        }
    },
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
    %{ if use_aws_logs }
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${app_log_group_name}",
            "awslogs-region": "${log_group_region}",
            "awslogs-stream-prefix": "${log_group_prefix}"
        }
    },
    %{ endif }
    "user": "${app_user}",
    "mountPoints": ${app_mount_points}
  }
]
