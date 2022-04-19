resource "aws_ec2_transit_gateway" "demo_tgw" {
  description = "demo_tgw"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "b1_vpc_tgw" {
  subnet_ids         = [aws_subnet.b1_privateSubnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
  vpc_id             = aws_vpc.b1_vpc.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "b2_vpc_tgw" {
  subnet_ids         = [aws_subnet.b2_privateSubnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
  vpc_id             = aws_vpc.b2_vpc.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.b3_privateSubnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
  vpc_id             = aws_vpc.b3_vpc.id
}