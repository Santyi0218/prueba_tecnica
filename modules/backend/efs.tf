resource "aws_efs_file_system" "storage" {
  creation_token = "storage_${var.name}"
  performance_mode = "generalPurpose"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "EFS_${var.name}"
  }
}

resource "aws_efs_mount_target" "subnet1_target" {
  file_system_id = aws_efs_file_system.storage.id
  subnet_id      = aws_subnet.private1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "subnet2_target" {
  file_system_id = aws_efs_file_system.storage.id
  subnet_id      = aws_subnet.private2.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "subnet3_target" {
  file_system_id = aws_efs_file_system.storage.id
  subnet_id      = aws_subnet.private3.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "subnet4_target" {
  file_system_id = aws_efs_file_system.storage.id
  subnet_id      = aws_subnet.private4.id
  security_groups = [aws_security_group.efs_sg.id]
}