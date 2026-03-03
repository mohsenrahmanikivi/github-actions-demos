provider "aws" {
    region = "eu-west-2"
    access_key = ""
    secret_key = ""
}

module "db_server" {
    source = "./ec2"
    ec2_name = "db_server"
    security_groups = null
    user_data = null  
}

output "db_server-private_ip" {
  value = module.db_server.private_ip
}


module "security_group" {
  source = "./sg"
}

module "web_server" {
    source = "./ec2"
    ec2_name = "web_server"
    security_groups = [module.security_group.name]
    user_data = file("webserver-script.sh") 
}

module "eip" {
  source = "./eip"
  instance_id = module.web_server.instance_id
}

output "public_ip" {
  value = module.eip.public_ip
}