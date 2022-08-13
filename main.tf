provider "aws" {
  region = "ap-southeast-2"
}

########################## Create VPCs ########################

resource "aws_vpc" "infra_vpc" {
  cidr_block                       = var.infra_vpc_cidrs
  assign_generated_ipv6_cidr_block = false
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    Name = "infra-vpc"
  }
}

resource "aws_vpc" "prod_vpc" {
  cidr_block                       = var.prod_vpc_cidrs
  assign_generated_ipv6_cidr_block = false
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"

  tags = {
    Name = "production-vpc"
  }
}

#################Associate Subnets to each VPC ########################

// Associate second cidr block and subnets to Production VPC
resource "aws_vpc_ipv4_cidr_block_association" "prod_priv_cidr" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = var.prod_second_cidr
}

resource "aws_subnet" "prod_priv01" {
  vpc_id                          = aws_vpc.prod_vpc.id
  cidr_block                      = var.prod_priv01
  availability_zone               = "ap-southeast-2a"
  assign_ipv6_address_on_creation = false

  tags = {
    Name = "prod-private01"
  }
}

resource "aws_subnet" "prod_priv02" {
  vpc_id                          = aws_vpc.prod_vpc.id
  cidr_block                      = var.prod_priv02
  availability_zone               = "ap-southeast-2b"
  assign_ipv6_address_on_creation = false
  tags = {
    Name = "prod-private02"
  }
}

resource "aws_subnet" "prod_priv03" {
  vpc_id                          = aws_vpc.prod_vpc.id
  cidr_block                      = var.prod_priv03
  availability_zone               = "ap-southeast-2c"
  assign_ipv6_address_on_creation = false
  tags = {
    Name = "prod-private03"
  }
}

resource "aws_subnet" "prod_priv04" {
  depends_on                      = [aws_vpc_ipv4_cidr_block_association.prod_priv_cidr]
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-2b"
  cidr_block                      = "100.64.0.0/18"
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "prod-private04"

  }
  vpc_id = aws_vpc.prod_vpc.id

  timeouts {}
}

resource "aws_subnet" "prod_priv05" {
  depends_on                      = [aws_vpc_ipv4_cidr_block_association.prod_priv_cidr]
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-2c"
  cidr_block                      = "100.64.128.0/18"
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "prod_private05"

  }
  vpc_id = aws_vpc.prod_vpc.id

  timeouts {}
}


// Associate second cidr block and subnets to Infrastructure VPC
resource "aws_vpc_ipv4_cidr_block_association" "infra_priv_cidr" {
  vpc_id     = aws_vpc.infra_vpc.id
  cidr_block = var.infra_pub
}


resource "aws_subnet" "infra_pub" {
  depends_on                      = [aws_vpc_ipv4_cidr_block_association.infra_priv_cidr]
  assign_ipv6_address_on_creation = false
  cidr_block                      = var.infra_pub
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "infra-pub"

  }
  vpc_id = aws_vpc.infra_vpc.id

  timeouts {}
}

resource "aws_subnet" "infra_priv" {
  depends_on                      = [aws_vpc_ipv4_cidr_block_association.infra_priv_cidr]
  assign_ipv6_address_on_creation = false
  cidr_block                      = var.infra_priv
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "infra-private"

  }
  vpc_id = aws_vpc.infra_vpc.id

  timeouts {}
}
// Create VPC peering

resource "aws_vpc_peering_connection" "vpcx1" {
  vpc_id      = aws_vpc.prod_vpc.id
  peer_vpc_id = "vpc-08ae5169e7ec206be"
  auto_accept = true

  tags = {
    "Name" = "pcx-1-prod-to-default"
  }
  depends_on = [
    aws_vpc.prod_vpc
  ]
}

resource "aws_vpc_peering_connection" "vpcx2" {
  vpc_id      = aws_vpc.prod_vpc.id
  peer_vpc_id = aws_vpc.infra_vpc.id
  auto_accept = true

  tags = {
    "Name" = "pcx-2-prod-to-infra"
  }
  depends_on = [
    aws_vpc.infra_vpc
  ]
}

// Create NAT Gateway with EIP
resource "aws_eip" "eip_inf_ngw" {
  vpc = true
}

resource "aws_nat_gateway" "infra_ngw" {
  allocation_id = aws_eip.eip_inf_ngw.id
  subnet_id     = aws_subnet.infra_pub.id

  tags = {
    Name = "NAT GW for Infra Pub"
  }
}

// Creat Internet Gateway for Default and Infra VPC
resource "aws_internet_gateway" "int_gw_1" {
  vpc_id = "vpc-08ae5169e7ec206be"

  tags = {
    Name = "internet-gateway-for-default"
  }
}

resource "aws_internet_gateway" "int_gw_2" {
  vpc_id = aws_vpc.infra_vpc.id

  tags = {
    Name = "internet-gateway-for-infra"
  }
}

// Route table

resource "aws_route_table" "prod_route" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
  }
}

resource "aws_route_table" "infra_priv1" {
  vpc_id = aws_vpc.infra_vpc.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = aws_nat_gateway.infra_ngw.id
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_peering_connection_id  = ""
      vpc_endpoint_id            = ""
      core_network_arn           = ""
    },
  ]
  tags = {
    "Name" = "rtb-infra-priv1"
  }

}

resource "aws_route_table" "infra_pub1" {
  vpc_id = aws_vpc.infra_vpc.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = aws_internet_gateway.int_gw_2.id
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_peering_connection_id  = ""
      vpc_endpoint_id            = ""
      core_network_arn           = ""
    },
  ]
  tags = {
    "Name" = "rtb-infra-priv1"
  }

}
