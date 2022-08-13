variable "vpc_count" {
  default = 2
}

variable "aws_vpc" {
  type    = list
  default = ["prod_vpc", "infra_vpc"]
}

variable "aws_cidr" {
  default = {
    "prod_cidr"      = "10.0.0.0/22"
    "infra_cidr"     = "172.30.0.0/24"
    "vpc-10-2"       = "10.2.0.0/16"
    "vpc-devt-projx" = "10.4.0.0/16"
  }
}
variable "infra_vpc_cidrs" {
    type        = string
    description = "Infrastructure VPC cidrS"
} 

variable "infra_pub" {
  type          = string
  description   = "Infra Public Subnet"
}

variable "infra_priv" {
  type           = string
  description = "Infra Private Subnet"
}

variable "prod_vpc_cidrs" {
  type           = string
  description = "Production VPC"
}

variable "prod_second_cidr" {
  type          = string
  description = "Prod Second cidr"
}
variable "prod_priv01" {
  type           = string
  description = "Private Subnet 01"
}

variable "prod_priv02" {
  type           = string
  description = "Private Subnet 01"
}

variable "prod_priv03" {
  type           = string
  description = "Private Subnet 01"
}

variable "prod_priv04" {
  type           = string
  description = "Private Subnet 01"
}

variable "prod_priv05" {
  type           = string
  description = "Private Subnet 01"
}