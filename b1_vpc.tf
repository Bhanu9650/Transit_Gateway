resource "aws_vpc" "b1_vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "b1_vpc"
    }
}

resource "aws_subnet" "b1_publicSubnet" {
    vpc_id     = aws_vpc.b1_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "b1_publicSubnet"
    }
}

resource "aws_subnet" "b1_privateSubnet" {
    vpc_id     = aws_vpc.b1_vpc.id
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "b1_publicSubnet"
    }
}

resource "aws_internet_gateway" "b1_IGW" {
    vpc_id = aws_vpc.b1_vpc.id
    tags = {
        Name = "b1_IGW"
    }
}

resource "aws_route_table" "b1_public_rt" {
    vpc_id = aws_vpc.b1_vpc.id
    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "b1_public_rt_association" {
    subnet_id      = aws_subnet.b1_publicSubnet.id
    route_table_id = aws_route_table.b1_public_rt.id
}

resource "aws_route" "r1" {
    route_table_id            = aws_route_table.b1_public_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.b1_IGW.id
}

resource "aws_route_table" "b1_private_rt" {
    vpc_id = aws_vpc.b1_vpc.id
    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table_association" "b1_private_rt_association" {
    subnet_id      = aws_subnet.b1_privateSubnet.id
    route_table_id = aws_route_table.b1_private_rt.id
}

resource "aws_nat_gateway" "b1_nat" {
    allocation_id = aws_eip.b1_nat_ip.id
    subnet_id     = aws_subnet.b1_publicSubnet.id
    tags = {
        Name = "gw NAT"
    }
}

resource "aws_eip" "b1_nat_ip" {
    vpc          = true
    # instance     = aws_instance.foo.id
    # depends_on   = [aws_internet_gateway.gw]
}

resource "aws_route" "r2" {
    route_table_id            = aws_route_table.b1_private_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_nat_gateway.b1_nat.id
}