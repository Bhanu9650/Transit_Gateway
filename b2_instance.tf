resource "aws_security_group" "b2_sg" {
    name   = "SSH, HTTP, HTTPS"
    vpc_id = aws_vpc.b2_vpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "b2_public" {
    ami           = "ami-0533f2ba8a1995cf9"
    instance_type = "t2.micro"
    key_name      = var.key_name

    subnet_id                   = aws_subnet.b2_publicSubnet.id
    vpc_security_group_ids      = [aws_security_group.b2_sg.id]
    associate_public_ip_address = true
    tags = {
        "Name" : "b2_public"
    }
}

resource "aws_instance" "b2_private" {
    ami           = "ami-0533f2ba8a1995cf9"
    instance_type = "t2.micro"
    key_name      = var.key_name

    subnet_id                   = aws_subnet.b2_privateSubnet.id
    vpc_security_group_ids      = [aws_security_group.b2_sg.id]
    associate_public_ip_address = false
    tags = {
        "Name" : "b2_private"
    }
}