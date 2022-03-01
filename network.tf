locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

//create a random variable so we dont have collisions 
resource "random_id" "random" {
  byte_length = 2
}


//This creates our own private slice of the AWS cloud
resource "aws_vpc" "mssaproj_vpc" {
  //vars are saved in the variables file
  cidr_block           = var.vpc_cidr //our cloud ip-space
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev-${random_id.random.dec}" //this will be the dev cloud and any additional instance of it
  }
  lifecycle {
    create_before_destroy = true //this allows us to transfer dependancies to the new VPC before destroying
  }
}
//setup the networks for our cloud
resource "aws_internet_gateway" "mssaproj_internet_gateway" {
  vpc_id = aws_vpc.mssaproj_vpc.id
  tags = {
    Name = "dev-igw-${random_id.random.dec}"
  }
}
resource "aws_route_table" "mssaproj_public_rt" {
  vpc_id = aws_vpc.mssaproj_vpc.id
  tags = {
    Name = "mssaproj-public"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mssaproj_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mssaproj_internet_gateway.id
}
resource "aws_default_route_table" "mssaproj_private_rt" {
  default_route_table_id = aws_vpc.mssaproj_vpc.default_route_table_id
  tags = {
    Name = "mssaproj-private"
  }
}

//Create a public subnets for all the front facing assets
resource "aws_subnet" "mssaproj_public_subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.mssaproj_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "mssaproj-public-${count.index + 1}"
  }
}
//Create a private subnets for all the front facing assets
resource "aws_subnet" "mssaproj_private_subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.mssaproj_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, length(local.azs) + count.index)
  map_public_ip_on_launch = false
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "mssaproj-private-${count.index + 1}"
  }
}
resource "aws_route_table_association" "mssaproj_public_association" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.mssaproj_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mssaproj_public_rt.id

}

resource "aws_security_group" "mssaproj_sg" {
  name        = "public_sg"
  description = "Security for public resources"
  vpc_id      = aws_vpc.mssaproj_vpc.id

}

resource "aws_security_group_rule" "ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip, var.cloud9_ip, "0.0.0.0/0"]//remove the "0.0.0.0/0" after demo
  security_group_id = aws_security_group.mssaproj_sg.id

}
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mssaproj_sg.id

}


