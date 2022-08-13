output "default_vpc" {
    value = aws_default_vpc.default_vpc.id
}
output "infra_vpc" {
  value = aws_vpc.infra_vpc.id
}

output "prod_vpc" {
    value = aws_vpc.prod_vpc.id
}