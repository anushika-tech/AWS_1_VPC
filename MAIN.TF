terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider – choose your region (example: Mumbai)
provider "aws" {
  region = "ap-south-1"
}

# Get available AZs (we'll use the first two)
data "aws_availability_zones" "available" {
  state = "available"
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "Anushika_Pandey_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Anushika_Pandey_VPC"
  }
}

# -----------------------------
# Public Subnets (2)
# -----------------------------
resource "aws_subnet" "Anushika_Pandey_public_subnet_1" {
  vpc_id                  = aws_vpc.Anushika_Pandey_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Anushika_Pandey_Public_Subnet_1"
  }
}

resource "aws_subnet" "Anushika_Pandey_public_subnet_2" {
  vpc_id                  = aws_vpc.Anushika_Pandey_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Anushika_Pandey_Public_Subnet_2"
  }
}

# -----------------------------
# Private Subnets (2)
# -----------------------------
resource "aws_subnet" "Anushika_Pandey_private_subnet_1" {
  vpc_id            = aws_vpc.Anushika_Pandey_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Anushika_Pandey_Private_Subnet_1"
  }
}

resource "aws_subnet" "Anushika_Pandey_private_subnet_2" {
  vpc_id            = aws_vpc.Anushika_Pandey_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Anushika_Pandey_Private_Subnet_2"
  }
}

# -----------------------------
# Internet Gateway (IGW)
# -----------------------------
resource "aws_internet_gateway" "Anushika_Pandey_igw" {
  vpc_id = aws_vpc.Anushika_Pandey_vpc.id

  tags = {
    Name = "Anushika_Pandey_IGW"
  }
}

# -----------------------------
# Elastic IP for NAT Gateway
# -----------------------------
resource "aws_eip" "Anushika_Pandey_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "Anushika_Pandey_NAT_EIP"
  }
}

# -----------------------------
# NAT Gateway (in Public Subnet 1)
# -----------------------------
resource "aws_nat_gateway" "Anushika_Pandey_nat_gw" {
  allocation_id = aws_eip.Anushika_Pandey_nat_eip.id
  subnet_id     = aws_subnet.Anushika_Pandey_public_subnet_1.id

  tags = {
    Name = "Anushika_Pandey_NAT_Gateway"
  }

  depends_on = [aws_internet_gateway.Anushika_Pandey_igw]
}

# -----------------------------
# Route Table – Public
# -----------------------------
resource "aws_route_table" "Anushika_Pandey_public_rt" {
  vpc_id = aws_vpc.Anushika_Pandey_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Anushika_Pandey_igw.id
  }

  tags = {
    Name = "Anushika_Pandey_Public_Route_Table"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "Anushika_Pandey_public_rt_assoc_1" {
  subnet_id      = aws_subnet.Anushika_Pandey_public_subnet_1.id
  route_table_id = aws_route_table.Anushika_Pandey_public_rt.id
}

resource "aws_route_table_association" "Anushika_Pandey_public_rt_assoc_2" {
  subnet_id      = aws_subnet.Anushika_Pandey_public_subnet_2.id
  route_table_id = aws_route_table.Anushika_Pandey_public_rt.id
}

# -----------------------------
# Route Table – Private (via NAT)
# -----------------------------
resource "aws_route_table" "Anushika_Pandey_private_rt" {
  vpc_id = aws_vpc.Anushika_Pandey_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Anushika_Pandey_nat_gw.id
  }

  tags = {
    Name = "Anushika_Pandey_Private_Route_Table"
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "Anushika_Pandey_private_rt_assoc_1" {
  subnet_id      = aws_subnet.Anushika_Pandey_private_subnet_1.id
  route_table_id = aws_route_table.Anushika_Pandey_private_rt.id
}

resource "aws_route_table_association" "Anushika_Pandey_private_rt_assoc_2" {
  subnet_id      = aws_subnet.Anushika_Pandey_private_subnet_2.id
  route_table_id = aws_route_table.Anushika_Pandey_private_rt.id
}

# -----------------------------
# Outputs (just to see IDs in CLI)
# -----------------------------
output "vpc_id" {
  value = aws_vpc.Anushika_Pandey_vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.Anushika_Pandey_public_subnet_1.id,
    aws_subnet.Anushika_Pandey_public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.Anushika_Pandey_private_subnet_1.id,
    aws_subnet.Anushika_Pandey_private_subnet_2.id
  ]
}
