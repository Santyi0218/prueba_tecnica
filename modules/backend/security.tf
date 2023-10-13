###SG BASTION
resource "aws_security_group" "bastion_sg" {
  name_prefix = "bastion-sg-${var.name}"
  vpc_id      = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] ##TRAFICO TOTAL A INTERNET
  }

  ingress {
    from_port   = 22
    to_port     = 22 ##SOLO SSH
    protocol    = "tcp"
    cidr_blocks = ["181.51.32.16/32"] ##MI IP CASA CLARO
    description = "Santiago_Villegas"
  }
  tags = {
    Name = "SG Bastion"
  }
}


### SG RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-${var.name}"
  vpc_id      = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    description = "Traffic from VPC"
  }
  tags = {
    Name = "SG RDS"
  }
}

resource "aws_security_group_rule" "rds_ingress_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "Traffic from Bastion"
}

resource "aws_security_group_rule" "rds_ingress_ecs_db" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "Traffic from ECS Fargate"
}

##SG WORDPRESS FARGATE
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg-${var.name}"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "SG ECS Fargate"
  }
}

resource "aws_security_group_rule" "ecs_ingress_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
  description              = "All traffic from EFS"
}

resource "aws_security_group_rule" "ecs_ingress_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "All traffic from ALB"
}

resource "aws_security_group_rule" "ecs_egress_efs" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "All traffic to ALB"
}

resource "aws_security_group_rule" "ecs_egress_rds" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
  description              = "Traffic to rds"
}

resource "aws_security_group_rule" "ecs_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
  description       = "Traffic to all"
}

##SG EFS
resource "aws_security_group" "efs_sg" {
  name_prefix = "efs-sg-${var.name}" ##Cambiar
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "SG EFS"
  }
}

resource "aws_security_group_rule" "efs_ingress_ecs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "All traffic from ECS Fargate"
}

# resource "aws_security_group_rule" "efs_ingress_bastion" {
#   type                     = "ingress"
#   from_port                = 2049
#   to_port                  = 2049
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.efs_sg.id
#   source_security_group_id = aws_security_group.bastion_sg.id
#   description              = "NFS traffic from Bastion"
# }

resource "aws_security_group_rule" "efs_egress_ecs" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "All traffic to ECS"
}

##SG ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg_${var.name}"
  description = "SG alb_${var.name}"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "SG ALB"
  }
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
  description       = "Traffic from all"
}

resource "aws_security_group_rule" "alb_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "Traffic to all"
}