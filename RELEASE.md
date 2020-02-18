RELEASE_TYPE: minor

task_definition/container_with_sidecar:
task_definition/single_container:

*   Added variables `ebs_volume_name` and `ebs_host_path`.  If you use these, the module will create a task definition with this volume/host path mapping, and the `attribute:ebs.volume exists` placement constraint.
*   Fix a bug where `mount_points` couldn't be specified correctly.

service/:

*   If you created a service which connected to a load balancer, the internal name of the service will have changed.  You need to use `terraform state mv` to select the new name.
