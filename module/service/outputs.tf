output "instance_public_dns" {
  value       = aws_instance.microk8s_demo.public_dns
  description = "show instance public host dns name"
}

output "load_balancer_dns" {
  value       = aws_lb.microk8s_demo.dns_name
  description = "show load balancer host dns name"
}
