resource "aws_vpc_peering_connection" "vpcx1" {
    vpc_id        = var.prod_vpc
    peer_vpc_id   = aws_default_vpc.default_vpc.id
    auto_accept   = true
    
    tags = {
        "Name" = "pcx-1-prod-to-default"
    }
}

resource "aws_vpc_peering_connection" "vpcx2" {
    vpc_id          = var.prod_vpc_id
    peer_vpc_id     = var.default_vpc_id
    auto_accept     = true
    
    tags = {
        "Name" = "pcx-2-prod-to-infra"
    }
}
