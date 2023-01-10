output "instance_public_dns" {
  value       = module.service.instance_public_dns
  description = "show instance public host dns name"
}

output "load_balancer_dns" {
  value       = module.service.load_balancer_dns
  description = "show load balancer host dns name"
}

output "current_aws_region" {
  value = module.service.current_aws_region
}

output "SSH_connect" {
    value = "ssh -i ${module.service.owner} ubuntu@${module.service.instance_public_dns}"
}

output "current_ip" {
  value = module.service.current_ip
}
