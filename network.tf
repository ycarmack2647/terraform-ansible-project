# network.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "${var.project_name}-vpc" }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project_name}-public-subnet" }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project_name}-public-subnet" }
}

# network.tf

# Private Subnet in AZ 1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "${var.project_name}-private-subnet-az1" }
}

# Private Subnet in AZ 2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "${var.project_name}-private-subnet-az2" }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat_gw_eip_az1" {
  vpc = true
  tags = {
    Name = "${var.project_name}-nat-eip-az1"
  }
}

resource "aws_eip" "nat_gw_eip_az2" {
  vpc = true
  tags = {
    Name = "${var.project_name}-nat-eip-az2"
  }
}

# Create NAT Gateway for AZ1 (in public subnet az1)
resource "aws_nat_gateway" "nat_gw_az1" {
  allocation_id = aws_eip.nat_gw_eip_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id # Reference the public subnet in AZ1
  tags = {
    Name = "${var.project_name}-nat-gw-az1"
  }
}

# Create NAT Gateway for AZ2 (in public subnet az2)
resource "aws_nat_gateway" "nat_gw_az2" {
  allocation_id = aws_eip.nat_gw_eip_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id # Reference the public subnet in AZ2
  tags = {
    Name = "${var.project_name}-nat-gw-az2"
  }
}

# Private Route Table for AZ1
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-private-rt-az1" }
}

# Private Route Table for AZ2
resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-private-rt-az2" }
}

# Add default route to Private Route Table for AZ1
resource "aws_route" "private_default_route_az1" {
  route_table_id         = aws_route_table.private_rt_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az1.id # Route through NAT Gateway in AZ1
}

# Add default route to Private Route Table for AZ2
resource "aws_route" "private_default_route_az2" {
  route_table_id         = aws_route_table.private_rt_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_az2.id # Route through NAT Gateway in AZ2
}

# Associate Private Subnet in AZ1 with the Private Route Table for AZ1
resource "aws_route_table_association" "private_subnet_association_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id # Private subnet in AZ1
  route_table_id = aws_route_table.private_rt_az1.id
}

# Associate Private Subnet in AZ2 with the Private Route Table for AZ2
resource "aws_route_table_association" "private_subnet_association_az2" {
  subnet_id      = aws_subnet.private_subnet_az2.id # Private subnet in AZ2
  route_table_id = aws_route_table.private_rt_az2.id
}





