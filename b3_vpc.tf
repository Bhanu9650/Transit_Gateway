resource "aws_vpc" "b3_vpc" {
    cidr_block       = "10.1.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "b3_vpc"
    }
}

resource "aws_subnet" "b3_publicSubnet" {
    vpc_id     = aws_vpc.b3_vpc.id
    cidr_block = "10.1.1.0/24"
    tags = {
        Name = "b3_publicSubnet"
    }
}

resource "aws_subnet" "b3_privateSubnet" {
    vpc_id     = aws_vpc.b3_vpc.id
    cidr_block = "10.1.2.0/24"
    tags = {
        Name = "b3_publicSubnet"
    }
}

resource "aws_internet_gateway" "b3_IGW" {
    vpc_id = aws_vpc.b3_vpc.id
    tags = {
        Name = "b3_IGW"
    }
}

resource "aws_route_table" "b3_public_rt" {
    vpc_id = aws_vpc.b3_vpc.id
    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "b3_public_rt_association" {
    subnet_id      = aws_subnet.b3_publicSubnet.id
    route_table_id = aws_route_table.b3_public_rt.id
}

resource "aws_route" "r1" {
    route_table_id            = aws_route_table.b3_public_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.b3_IGW.id
}

resource "aws_route_table" "b3_private_rt" {
    vpc_id = aws_vpc.b3_vpc.id
    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table_association" "b3_private_rt_association" {
    subnet_id      = aws_subnet.b3_privateSubnet.id
    route_table_id = aws_route_table.b3_private_rt.id
}

resource "aws_nat_gateway" "b3_nat" {
    allocation_id = aws_eip.b3_nat_ip.id
    subnet_id     = aws_subnet.b3_publicSubnet.id
    tags = {
        Name = "gw NAT"
    }
}

resource "aws_eip" "b3_nat_ip" {
    vpc          = true
    # instance     = aws_instance.foo.id
    # depends_on   = [aws_internet_gateway.gw]
}

resource "aws_route" "r2" {
    route_table_id            = aws_route_table.b3_private_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_nat_gateway.b3_nat.id
}