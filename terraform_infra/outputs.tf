output "db_server-private_ip" {
  value = module.db_server.private_ip
}


output "public_ip" {
  value = module.eip.public_ip
}