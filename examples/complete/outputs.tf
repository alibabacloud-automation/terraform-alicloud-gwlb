# Outputs for GWLB complete example

# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = local.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = length(data.alicloud_vpcs.existing.ids) > 0 ? data.alicloud_vpcs.existing.vpcs[0].cidr_block : alicloud_vpc.example[0].cidr_block
}

# VSwitch outputs
output "vswitch_ids" {
  description = "The IDs of the VSwitches"
  value       = alicloud_vswitch.example[*].id
}

output "vswitch_cidr_blocks" {
  description = "The CIDR blocks of the VSwitches"
  value       = alicloud_vswitch.example[*].cidr_block
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.example.id
}

# ECS Instance outputs
output "instance_ids" {
  description = "The IDs of the ECS instances"
  value       = alicloud_instance.example[*].id
}

output "instance_names" {
  description = "The names of the ECS instances"
  value       = alicloud_instance.example[*].instance_name
}

output "instance_private_ips" {
  description = "The private IP addresses of the ECS instances"
  value       = alicloud_instance.example[*].private_ip
}

# GWLB Module outputs
output "gwlb_load_balancer_id" {
  description = "The ID of the GWLB load balancer"
  value       = module.gwlb.gwlb_load_balancer_id
}

output "gwlb_load_balancer_name" {
  description = "The name of the GWLB load balancer"
  value       = module.gwlb.gwlb_load_balancer_name
}

output "gwlb_load_balancer_status" {
  description = "The status of the GWLB load balancer"
  value       = module.gwlb.gwlb_load_balancer_status
}

output "gwlb_server_group_id" {
  description = "The ID of the GWLB server group"
  value       = module.gwlb.gwlb_server_group_id
}

output "gwlb_server_group_name" {
  description = "The name of the GWLB server group"
  value       = module.gwlb.gwlb_server_group_name
}

output "gwlb_listener_id" {
  description = "The ID of the GWLB listener"
  value       = module.gwlb.gwlb_listener_id
}

output "gwlb_complete_setup" {
  description = "Complete GWLB setup information"
  value       = module.gwlb.gwlb_complete_setup
}