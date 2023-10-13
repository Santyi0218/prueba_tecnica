##VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.1.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC_${var.name}"
  }
}

##SUBNETS
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.32/27"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Subnet_private1_${var.name}"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.64/27"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Subnet_private2_${var.name}"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.96/27"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "Subnet_private3_${var.name}"
  }
}

resource "aws_subnet" "private4" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.128/27"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = false
  tags = {
    Name = "Subnet_private4_${var.name}"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/27" #Se puede limitar más
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true #Auto asign PublicIP
  tags = {
    Name = "Subnet1_public_${var.name}"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.160/27" #Se puede limitar más
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true #Auto asign PublicIP
  tags = {
    Name = "Subnet2_public_${var.name}"
  }
}

##INTERNET GATEWAYS
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Internet_Gateway_${var.name}"
  }
}

##NAT GATEWAYS
resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = "eipalloc-0ff1062ab3a84ce11"
  subnet_id     = aws_subnet.private1.id
  tags = {
    Name = "NAT_Gateway_${var.name}"
  }
}

##ELASTIC IP
resource "aws_eip" "main_eip" {
  instance = aws_instance.bastion.id
  tags = {
    Name = "Elastip_IP_${var.name}"
  }
}

##ROUTE TABLES
###Route table Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "rt_pub_${var.name}"
  }
}

resource "aws_route_table_association" "public1_associaton" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_associaton" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

###Route table private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_nat_gateway.id
  }
  tags = {
    Name = "rt_priv_${var.name}"
  }
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_association3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_association4" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private.id
}
