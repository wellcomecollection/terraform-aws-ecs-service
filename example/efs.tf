resource "aws_efs_file_system" "efs_fs" {
  creation_token = "example_efs_fs"
}

resource "aws_efs_mount_target" "efs_fs" {
  for_each = toset(local.private_subnets)

  file_system_id  = aws_efs_file_system.efs_fs.id
  subnet_id       = each.key
  security_groups = [
    aws_security_group.nfs_inbound.id
  ]
}
