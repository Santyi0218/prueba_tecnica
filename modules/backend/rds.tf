resource "aws_db_subnet_group" "sg_group_db" {
  description = "Subnet Group for RDS ${var.name}"
  name        = "main_subnet_group_db_${var.name}"
  subnet_ids  = [aws_subnet.private1.id, aws_subnet.private2.id]
  tags = {
    Name = "Subnet_group_db_${var.name}"
  }
}

resource "aws_db_instance" "rds_mysql" {
  identifier                  = "bd-${var.name}"
  allocated_storage           = 10
  db_name                     = "bd_${var.name}"
  engine                      = "mysql"
  engine_version              = "8.0.33"
  instance_class              = "db.t4g.micro"
  manage_master_user_password = true
  username                    = "foo" ##Cambiar esto a PARAMETER STORE
  parameter_group_name        = "default.mysql8.0"
  publicly_accessible         = false
  multi_az                    = false
  deletion_protection         = true
  port                        = 3306
  #VPC
  db_subnet_group_name   = aws_db_subnet_group.sg_group_db.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  lifecycle {
    ignore_changes = [engine_version, parameter_group_name]
  }
  tags = {
    Name = "RDS_MySQL_${var.name}"
  }
}