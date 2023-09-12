resource "aws_ebs_volume" "ec2" {
  availability_zone = local.subnet_public[0].availability_zone
  size              = 10
  type              = local.vars.ebs_volumn_type

  tags = {
    Name = "devops-ebs-ec2"
  }
}

resource "aws_network_interface" "ec2" {
  subnet_id       = local.subnet_public[0].id
  security_groups = [aws_security_group.ec2.id]
}

resource "aws_security_group" "ec2" {
  name   = "devops-ec2-security-group"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-ec2-security-group"
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-ssh-key"
  public_key = file(local.vars.ec2_ssh_public_key_path)
}

resource "aws_instance" "ec2" {
  ami           = "ami-0df7a207adb9748c7" # data.aws_ami.ubuntu.id
  instance_type = local.vars.ec2_instance_type


  network_interface {
    network_interface_id = aws_network_interface.ec2.id
    device_index         = 0
  }

  key_name = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = "devops-ec2"
  }
}

resource "aws_volume_attachment" "ec2_ubuntu" {
  device_name = "/dev/sda2"
  volume_id   = aws_ebs_volume.ec2.id
  instance_id = aws_instance.ec2.id
}

resource "aws_eip" "ec2" {
  instance = aws_instance.ec2.id

  domain = "vpc"

  tags = {
    Name = "devops-ec2-eip"
  }
}