provider "aws" {
    region = "eu-west-2"
    access_key = ""
    secret_key = ""
}

module "db_server" {
    source = "../../module2/ec2"
    ec2_name = "db_server"
    security_groups = null
    user_data = null  
}