variable "key" {
    type = list(string)
    default = [ "", "" ] 
}

variable "input" {
    description = "Please enter the VPC name?"
    type = string  
}

output "outputPrint" {
    description = "This is the VPC ID "
    value = aws_vpc.main_vpc.id
}

provider "aws" {
    region = "eu-west-1"
    access_key = var.key[0]
    secret_key = var.key[1]
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "main_vpc"
    }
}