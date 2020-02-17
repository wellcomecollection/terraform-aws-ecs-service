RELEASE_TYPE: minor

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added variables `ebs_volume_name` and `ebs_host_path`.  If you use these, the module will create a task definition with this volume/host path mapping, and the `attribute:ebs.volume exists` placement constraint.
