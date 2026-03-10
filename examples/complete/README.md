# Complete GWLB Example

This example demonstrates how to create a complete Gateway Load Balancer (GWLB) setup using the terraform-alicloud-gwlb module.

## What This Example Creates

- **VPC**: A Virtual Private Cloud with the specified CIDR block
- **VSwitches**: Multiple VSwitches in different availability zones
- **Security Group**: A security group with HTTP/HTTPS access rules
- **ECS Instances**: Backend servers that will be registered with the GWLB server group
- **GWLB Load Balancer**: The main load balancer resource
- **GWLB Server Group**: Server group containing the ECS instances
- **GWLB Listener**: Listener to handle traffic forwarding

## Architecture

```
Internet
    |
    v
[GWLB Load Balancer]
    |
    v
[GWLB Server Group]
    |
    v
[Backend ECS Instances]
```

## Cost Notice

**Note:** This example will create real resources on Alibaba Cloud that may incur costs. Resources include VPC, VSwitches, ECS instances, Security Groups, and GWLB resources (Load Balancer, Server Group, and Listener). Please ensure you understand the pricing before running this example. Remember to run `terraform destroy` to clean up resources when you're done.

## Usage

To run this example:

1. Clone the repository and navigate to this example directory:
   ```bash
   cd examples/complete
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and customize the variables in `terraform.tfvars` (optional):
   ```hcl
   vpc_name     = "my-gwlb-vpc"
   gwlb_name    = "my-gwlb"
   instance_count = 5
   
   tags = {
     Environment = "production"
     Team        = "platform"
   }
   ```

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

6. Clean up when done:
   ```bash
   terraform destroy
   ```

## Notes

- **Zone Configuration**: The example creates VSwitches in multiple zones. Make sure the specified zones are available in your region.
- **Instance Types**: The example automatically selects available instance types with 2 CPU cores and 4GB memory.
- **Health Checks**: The server group is configured with HTTP health checks on port 80 with path `/health`.
- **Security**: The security group allows HTTP (80) and HTTPS (443) traffic from anywhere. Adjust as needed for your security requirements.

## Clean Up

To destroy all resources created by this example:

```bash
terraform destroy
```

Confirm the destruction when prompted.