provider "aws" {
    region = "eu-west-2"
    access_key = "AKIATILPJ5ON72XEXPWR"
    secret_key = "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"
}

module "db_server" {
    source = "../../module2/ec2"
    ec2_name = "db_server"
    security_groups = null
    user_data = null  
}