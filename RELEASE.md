RELEASE_TYPE: minor

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added variables `efs_volume_name` and `efs_host_path`.  If you use these, the module will create a task definition with this volume/host path mapping, and the `attribute:efs.volume exists` placement constraint.

task_definition/single_container:

*   Added variable `container_port` and `container_name` if you want to expose a port inside your container to a load balancer or similar.
