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

## Configuration

### Required Variables

None. All variables have sensible defaults.

### Optional Variables

- `vpc_name`: Name of the VPC (default: "gwlb-example-vpc")
- `vpc_cidr`: CIDR block for the VPC (default: "10.0.0.0/8")
- `vswitch_configs`: List of VSwitch configurations
- `instance_count`: Number of backend ECS instances (default: 3)
- `gwlb_name`: Name of the GWLB load balancer (default: "gwlb-example")
- `tags`: Map of tags to assign to resources

### Outputs

This example outputs:
- VPC and VSwitch information
- Security Group ID
- ECS instance details
- Complete GWLB setup information including load balancer, server group, and listener details

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