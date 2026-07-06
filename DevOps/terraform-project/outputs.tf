
output "frontend_public_ip" {
  value = module.ec2.frontend_public_ip
}

output "backend_private_ip" {
  value = module.ec2.backend_private_ip
}

output "frontend_instance_id" {
  value = module.ec2.frontend_instance_id
}

output "backend_instance_id" {
  value = module.ec2.backend_instance_id
}