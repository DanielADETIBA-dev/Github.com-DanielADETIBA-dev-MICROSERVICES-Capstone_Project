resource "aws_vpc" "deployment-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "deployment-subnet-1" {
  vpc_id            = aws_vpc.deployment-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}


resource "aws_subnet" "deployment-subnet-2" {
  vpc_id            = aws_vpc.deployment-vpc.id
  cidr_block        = var.subnet_cidr_block2
  availability_zone = var.avail_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-subnet-2"
  }
}


resource "aws_subnet" "deployment-subnet-3" {
  vpc_id            = aws_vpc.deployment-vpc.id
  cidr_block        = var.subnet_cidr_block3
  availability_zone = var.avail_zone3
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-subnet-3"
  }
}


resource "aws_internet_gateway" "deployment-igw" {
  vpc_id = aws_vpc.deployment-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.deployment-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deployment-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.deployment-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}




resource "aws_security_group" "allow-inbound-traffic" {
  vpc_id = aws_vpc.deployment-vpc.id

  ingress {
    description = "allow inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-new-sg"
  }
}