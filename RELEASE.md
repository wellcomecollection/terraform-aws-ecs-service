RELEASE_TYPE: patch

task_definition/container_with_sidecar:

*   Fix a bug introduced in v1.5.0 that would lead to an error when trying to plan:

    > task_definition.tf line 51: An argument definition must end with a newline.
