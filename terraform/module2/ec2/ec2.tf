
variable "security_groups" {
    type = list(string)
}

variable "user_data" {
  type = string
}

variable "ec2_name" {
    type = string
}

resource "aws_instance" "ec2_instance" {
    ami = "ami-0ba0c1a358147d1a8"
    instance_type = "t2.micro"
    security_groups = var.security_groups
    user_data = var.user_data
    tags = {
        Name = var.ec2_name
    }
}