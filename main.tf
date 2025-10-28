provider "aws" {
  alias  = "south"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

resource "aws_vpc" "south_vpc" {
  provider = aws.south
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "south-vpc" }
}

resource "aws_subnet" "south_subnet" {
  provider = aws.south
  vpc_id = aws_vpc.south_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  tags = { Name = "south-subnet" }
}

resource "aws_security_group" "south_sg" {
  provider = aws.south
  vpc_id = aws_vpc.south_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "south-sg" }
}

resource "aws_instance" "south_instance" {
  provider = aws.south
  ami           = "ami-00af95fa354fdb788" # ap-south-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.south_subnet.id
  vpc_security_group_ids = [aws_security_group.south_sg.id]
  associate_public_ip_address = true
  tags = { Name = "south-ec2" }
}

resource "aws_vpc" "east_vpc" {
  provider = aws.east
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "east-vpc" }
}

resource "aws_subnet" "east_subnet" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = { Name = "east-subnet" }
}

resource "aws_security_group" "east_sg" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "east-sg" }
}

resource "aws_instance" "east_instance" {
  provider = aws.east
  ami           = "ami-07860a2d7eb515d9a" # us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.east_subnet.id
  vpc_security_group_ids = [aws_security_group.east_sg.id]
  associate_public_ip_address = true
  tags = { Name = "east-ec2" }
}

output "south_ec2_public_ip" {
  value = aws_instance.south_instance.public_ip
}

output "east_ec2_public_ip" {
  value = aws_instance.east_instance.public_ip
}
