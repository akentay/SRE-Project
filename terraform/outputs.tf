# outputs.tf — Values displayed after terraform apply completes
# Kentay Aida | SE-2428 | SRE Course 2026

output "instance_public_ip" {
  description = "Public IP address of the MedBook server"
  value       = aws_instance.medbook_server.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.medbook_server.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.medbook_sg.id
}

output "medbook_service_urls" {
  description = "URLs to access all MedBook services after deployment"
  value = {
    frontend   = "http://${aws_instance.medbook_server.public_ip}:8081"
    backend    = "http://${aws_instance.medbook_server.public_ip}:3000"
    prometheus = "http://${aws_instance.medbook_server.public_ip}:9090"
    grafana    = "http://${aws_instance.medbook_server.public_ip}:3001"
    alertmgr   = "http://${aws_instance.medbook_server.public_ip}:9093"
  }
}
