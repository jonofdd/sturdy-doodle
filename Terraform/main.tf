resource "aws_vpc" "al_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_key_pair" "al-key" {
  key_name   = "hurez@DESKTOP-G7B1SVC"
  public_key = file("C:\\Users\\hurez\\.ssh\\id_ed25519.pub")
}

resource "aws_subnet" "al_subnet" {
  vpc_id     = aws_vpc.al_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "al_igw" {
  vpc_id = aws_vpc.al_vpc.id
}

resource "aws_route_table" "al_route_table" {
  vpc_id = aws_vpc.al_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.al_igw.id
  }
}

resource "aws_route_table_association" "al_route_table_association" {
  subnet_id      = aws_subnet.al_subnet.id
  route_table_id = aws_route_table.al_route_table.id
}

resource "aws_security_group" "al_sg" {
  vpc_id = aws_vpc.al_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25
    to_port     = 25
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
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9091
    to_port     = 9091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9101
    to_port     = 9101
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8100
    to_port     = 8100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9102
    to_port     = 9102
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9103
    to_port     = 9103
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9104
    to_port     = 9104
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9105
    to_port     = 9105
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "al_instance" {
  count         = 3
  ami           = "ami-054a53dca63de757b"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.al_subnet.id
  key_name      = "hurez@DESKTOP-G7B1SVC"

  private_ip = "10.0.1.${count.index + 10}"

  security_groups = [aws_security_group.al_sg.id]

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Cluster-instance-${count.index + 1}"
  }
}

resource "aws_route53_zone" "al_zone" {
  name = "alart.studio"
}

resource "aws_route53_record" "al_dns_instances" {
  count   = 3
  zone_id = aws_route53_zone.al_zone.zone_id
  name    = "instance-${count.index + 1}.alart.studio"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.al_instance[count.index].public_ip]
}