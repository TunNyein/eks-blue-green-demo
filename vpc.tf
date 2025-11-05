#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_address_space
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.vpc_prefix}-vpc"
    Environment = var.vpc_environment
  }
}

#------------------------------------------------------------------------------
# Internet Gateway
#------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_prefix}-igw"
  }
}

#------------------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet01" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_public_subnet_cidr[0]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_prefix}-public-subnet01"
  }
}

resource "aws_subnet" "public_subnet02" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_public_subnet_cidr[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_prefix}-public-subnet02"
  }
}


#------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_private_subnet_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_prefix}-private-subnet01"
  }
}

resource "aws_subnet" "private_subnet02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_private_subnet_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.vpc_prefix}-private-subnet02"
  }
}

#------------------------------------------------------------------------------
# Elastic IP for NAT Gateway
#------------------------------------------------------------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_prefix}-nat-eip"
  }
}

#------------------------------------------------------------------------------
# NAT Gateway
#------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet01.id

  tags = {
    Name = "${var.vpc_prefix}-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

#------------------------------------------------------------------------------
# Route Tables
#------------------------------------------------------------------------------

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_prefix}-public-rt"
  }
}

# Private Route Tables
resource "aws_route_table" "private_rt01" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.vpc_prefix}-private-rt01"
  }
}

resource "aws_route_table" "private_rt02" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.vpc_prefix}-private-rt02"
  }
}

#------------------------------------------------------------------------------
# Route Table Associations
#------------------------------------------------------------------------------
resource "aws_route_table_association" "public_asso01" {
  subnet_id      = aws_subnet.public_subnet01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_asso02" {
  subnet_id      = aws_subnet.public_subnet02.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_asso01" {
  subnet_id      = aws_subnet.private_subnet01.id
  route_table_id = aws_route_table.private_rt01.id
}

resource "aws_route_table_association" "private_asso02" {
  subnet_id      = aws_subnet.private_subnet02.id
  route_table_id = aws_route_table.private_rt02.id
}
