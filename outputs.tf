output "vpc_id" {
  value = [
    for s in data.aws_vpc.selected : s
  ]
}

output "subnet_private_cidr_blocks" {
  value = [
    for s in data.aws_subnet.all : s
    if can(regex("^vpc-private-subnet-", s.tags.name))
  ]
}

output "ec2_ami" {
  value = data.aws_ami.ubuntu
}

output "rds_mysql" {
  sensitive = true
  value     = aws_db_instance.default
}

output "ec2_public_dns" {
  value = aws_instance.ec2.public_dns
}