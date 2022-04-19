resource "aws_vpc" "b2_vpc" {
    cidr_block       = "10.1.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "b2_vpc"
    }
}

resource "aws_subnet" "b2_publicSubnet" {
    vpc_id     = aws_vpc.b2_vpc.id
    cidr_block = "10.1.1.0/24"
    tags = {
        Name = "b2_publicSubnet"
    }
}

resource "aws_subnet" "b2_privateSubnet" {
    vpc_id     = aws_vpc.b2_vpc.id
    cidr_block = "10.1.2.0/24"
    tags = {
        Name = "b2_publicSubnet"
    }
}

resource "aws_internet_gateway" "b2_IGW" {
    vpc_id = aws_vpc.b2_vpc.id
    tags = {
        Name = "b2_IGW"
    }
}

resource "aws_route_table" "b2_public_rt" {
    vpc_id = aws_vpc.b2_vpc.id
    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "b2_public_rt_association" {
    subnet_id      = aws_subnet.b2_publicSubnet.id
    route_table_id = aws_route_table.b2_public_rt.id
}

resource "aws_route" "r1" {
    route_table_id            = aws_route_table.b2_public_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.b2_IGW.id
}

resource "aws_route_table" "b2_private_rt" {
    vpc_id = aws_vpc.b2_vpc.id
    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table_association" "b2_private_rt_association" {
    subnet_id      = aws_subnet.b2_privateSubnet.id
    route_table_id = aws_route_table.b2_private_rt.id
}

resource "aws_nat_gateway" "b2_nat" {
    allocation_id = aws_eip.b2_nat_ip.id
    subnet_id     = aws_subnet.b2_publicSubnet.id
    tags = {
        Name = "gw NAT"
    }
}

resource "aws_eip" "b2_nat_ip" {
    vpc          = true
    # instance     = aws_instance.foo.id
    # depends_on   = [aws_internet_gateway.gw]
}

resource "aws_route" "r2" {
    route_table_id            = aws_route_table.b2_private_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_nat_gateway.b2_nat.id
}