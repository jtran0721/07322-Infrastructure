//VPC variables

variable "infra_vpc_cidrs" {
  type        = string
  description = "Infrastructure VPC cidrS"
  default     = "172.30.0.0/24"
}

variable "infra_pub" {
  type        = string
  description = "Infra Public Subnet"
  default     = "172.130.0.0/27"
}

variable "infra_priv" {
  type        = string
  description = "Infra Private Subnet"
  default     = "172.30.0.128/27"
}

variable "prod_vpc_cidrs" {
  type        = string
  description = "Production VPC"
  default     = "10.0.0.0/22"
}

variable "prod_second_cidr" {
  type        = string
  description = "Prod Second cidr"
  default     = "100.64.0.0/16"
}
variable "prod_priv01" {
  type        = string
  description = "Private Subnet 01"
  default     = "10.0.1.0/24"
}

variable "prod_priv02" {
  type        = string
  description = "Private Subnet 02"
  default     = "10.0.2.0/24"
}

variable "prod_priv03" {
  type        = string
  description = "Private Subnet 03"
  default     = "10.0.3.0/24"
}

variable "prod_priv04" {
  type        = string
  description = "Private Subnet 04"
  default     = "100.64.0.0/18"
}

variable "prod_priv05" {
  type        = string
  description = "Private Subnet 05"
  default     = "100.64.128.0/18"
}

