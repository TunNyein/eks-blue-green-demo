output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet01.id,
    aws_subnet.public_subnet02.id,
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet01.id,
    aws_subnet.private_subnet02.id,
  ]
}
