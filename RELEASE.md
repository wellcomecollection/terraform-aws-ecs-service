RELEASE_TYPE: major

Simplifies volume mounting, and provides efs/fargate compatibility to task definitions.

In a task definition module:

```tf
// EC2 Host volume mounts
volumes = [{
  name = "ebs_volume"
  host_path = "/mnt/ebs"
},{
  name = "efs_volume"
  host_path = "/mnt/efs"
}]

// Specify your own placement constraints
placement_constraints = [{
  type       = "memberOf"
  expression = "attribute:efs.volume exists"
},{
  type       = "memberOf"
  expression = "attribute:ebs.volume exists"
}]


// Fargate EFS config
efs_volumes = [{
  name = local.efs_volume_name
  file_system_id = aws_efs_file_system.efs_fs.id
  root_directory = "/"
}]
```

