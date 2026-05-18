# MedBook SRE — Terraform Infrastructure

**Student:** Kentay Aida | SE-2428  
**Course:** Site Reliability Engineering  
**Assignment:** 5 — Infrastructure as Code

## What This Creates
- 1x EC2 t3.medium instance (Ubuntu 22.04 LTS, 2 vCPU, 4 GB RAM)
- 1x Security Group with ports: 22 (SSH), 80 (HTTP), 3000-3001 (API+Grafana), 9090 (Prometheus)
- Docker + Docker Compose pre-installed via user_data script

## How to Deploy

### Prerequisites
1. Install Terraform: https://developer.hashicorp.com/terraform/downloads
2. Install AWS CLI: https://aws.amazon.com/cli/
3. Run: `aws configure` (enter your Access Key, Secret Key, region: us-east-1)

### Deployment Commands
```bash
cd terraform/
terraform init      # Download AWS provider plugin
terraform plan      # Preview what will be created (safe, nothing happens)
terraform apply     # Create the infrastructure (type 'yes' to confirm)
```

### After Deployment
Get the public IP from the output and access:
- Frontend:   http://<IP>:8081
- Backend:    http://<IP>:3000
- Prometheus: http://<IP>:9090
- Grafana:    http://<IP>:3001  (login: admin / medbook123)

### Cleanup
```bash
terraform destroy   # Removes all created resources — avoids AWS charges
```

## Files
| File | Purpose |
|------|---------|
| main.tf | AWS provider, Security Group, EC2 instance |
| variables.tf | Input variable declarations |
| outputs.tf | Public IP and service URL outputs |
| terraform.tfvars | Actual values for variables |
