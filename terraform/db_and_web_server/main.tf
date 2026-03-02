variable "key" {
    type = list(string)
    default = [ "", "" ] 
}

provider "aws" {
    region = "eu-west-2"
    access_key = var.key[0]
    secret_key = var.key[1]
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "main_vpc"
    }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_subnet" "web_subnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.main_vpc.id
  map_public_ip_on_launch = true
  tags = {
        name = "web_subnet"
     }
}

resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "web_rt"
  }
}

resource "aws_route_table_association" "web_subnet_assoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rt.id
}




resource "aws_security_group" "allow_web_traffic" {
  name   = "allow-web-traffic"
  vpc_id = aws_vpc.main_vpc.id

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
    Name = "allow_web_traffic"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0ba0c1a358147d1a8"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web_subnet.id
  vpc_security_group_ids = [ aws_security_group.allow_web_traffic.id ]
  user_data = file("webserver-script.sh")
  tags = {
    name = "web-server"
  }
}

resource "aws_instance" "db" {
  ami = "ami-0ba0c1a358147d1a8"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web_subnet.id

  tags = {
    name = "db-server"
  }
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}

output "PrivateIP" {
  value = aws_instance.db.private_ip
}

output "PublicIP" {
  value = aws_eip.web_ip.public_ip
}