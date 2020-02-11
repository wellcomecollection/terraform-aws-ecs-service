RELEASE_TYPE: minor

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added a `use_awslogs` variable which includes the `loggingConfiguration` block from previous versions if `true`. Defaults to `false`, omitting all logging config. 