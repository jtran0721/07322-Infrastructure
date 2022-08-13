provider "aws" {
    region = "ap-southeast-2"
}

########################## Create VPCs ########################

resource "aws_vpc" "VPC" {
  count                            = var.vpccount
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = lookup(var.aws_cidr, var.aws_vpc[count.index])
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    "Name" = var.aws_vpc[count.index]
  }
}

#################Associate Subnets to each VPC ########################

// Associate second cidr block and subnets to Infra VPC
resource "aws_vpc_ipv4_cidr_block_association" "infra_priv_cidr" {
    vpc_id     = aws_vpc.infra_vpc.id
    cidr_block = var.infra_pub

}

// Associate second cidr block and subnets to Production VPC
resource "aws_vpc_ipv4_cidr_block_association" "prod_priv_cidr" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = var.prod_second_cidr
}

resource "aws_subnet" "prod_priv01" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = var.prod_priv01
    availability_zone = "ap-southeast-2a"
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "prod-private01"
    }
}

resource "aws_subnet" "prod_priv02" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = var.prod_priv02
    availability_zone = "ap-southeast-2b"
    assign_ipv6_address_on_creation = false
    tags = {
        Name = "prod-private02"
    }
}

resource "aws_subnet" "prod_priv03" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = var.prod_priv03
    availability_zone = "ap-southeast-2c"
    assign_ipv6_address_on_creation = false
    tags = {
        Name = "prod-private03"
    }
}


resource "aws_subnet" "prod_priv05" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = var.prod_priv05
    assign_ipv6_address_on_creation = false
    tags = {
        Name = "prod-second-private02"
    }
}

