data "aws_vpc" "selected" {
  filter {
    name   = "tag:name"
    values = ["devops-vpc"]
  }
}

data "aws_subnets" "vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.vpc.ids)
  id       = each.value
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}