resource "aws_instance" "bastion" {
  ami             = "ami-041feb57c611358bd"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public1.id
  key_name        = "access"
  security_groups = [aws_security_group.bastion_sg.id]
  tags = {
    Name = "Bastion_${var.name}"
  }
}