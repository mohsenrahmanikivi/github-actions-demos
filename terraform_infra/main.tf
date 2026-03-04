provider "aws" {
  region = var.aws_region
}

module "db_server" {
  source          = "./modules/ec2"
  ec2_name        = "db_server"
  security_groups = null
  user_data       = null
}


module "security_group" {
  source = "./modules/sg"
}

module "web_server" {
  source          = "./modules/ec2"
  ec2_name        = "web_server"
  security_groups = [module.security_group.name]
  user_data       = file("./scripts/webserver-script.sh")
}

module "eip" {
  source      = "./modules/eip"
  instance_id = module.web_server.instance_id
}

