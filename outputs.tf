# Output definitions for GWLB Module

# GWLB Load Balancer outputs
output "gwlb_load_balancer_id" {
  description = "The ID of the GWLB load balancer"
  value       = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].id : var.load_balancer_id
}

output "gwlb_load_balancer_name" {
  description = "The name of the GWLB load balancer"
  value       = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].load_balancer_name : null
}

output "gwlb_load_balancer_status" {
  description = "The status of the GWLB load balancer"
  value       = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].status : null
}

output "gwlb_load_balancer_create_time" {
  description = "The creation time of the GWLB load balancer"
  value       = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].create_time : null
}

output "gwlb_load_balancer_zone_mappings" {
  description = "The zone mappings of the GWLB load balancer with load balancer addresses"
  value       = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].zone_mappings : []
}

# GWLB Server Group outputs
output "gwlb_server_group_id" {
  description = "The ID of the GWLB server group"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].id : var.server_group_id
}

output "gwlb_server_group_name" {
  description = "The name of the GWLB server group"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].server_group_name : null
}

output "gwlb_server_group_type" {
  description = "The type of the GWLB server group"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].server_group_type : null
}

output "gwlb_server_group_status" {
  description = "The status of the GWLB server group"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].status : null
}

output "gwlb_server_group_create_time" {
  description = "The creation time of the GWLB server group"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].create_time : null
}

output "gwlb_server_group_servers" {
  description = "The servers in the GWLB server group with their status"
  value       = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].servers : []
}

# GWLB Listener outputs
output "gwlb_listener_id" {
  description = "The ID of the GWLB listener"
  value       = var.create_listener ? alicloud_gwlb_listener.listener[0].id : null
}

output "gwlb_listener_status" {
  description = "The status of the GWLB listener"
  value       = var.create_listener ? alicloud_gwlb_listener.listener[0].status : null
}

output "gwlb_listener_region_id" {
  description = "The region ID of the GWLB listener"
  value       = var.create_listener ? alicloud_gwlb_listener.listener[0].region_id : null
}

# Combined outputs for convenience
output "gwlb_complete_setup" {
  description = "Complete GWLB setup information including load balancer, server group, and listener"
  value = {
    load_balancer = {
      id          = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].id : var.load_balancer_id
      name        = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].load_balancer_name : null
      status      = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].status : null
      create_time = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].create_time : null
    }
    server_group = {
      id          = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].id : var.server_group_id
      name        = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].server_group_name : null
      type        = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].server_group_type : null
      status      = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].status : null
      create_time = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].create_time : null
    }
    listener = {
      id        = var.create_listener ? alicloud_gwlb_listener.listener[0].id : null
      status    = var.create_listener ? alicloud_gwlb_listener.listener[0].status : null
      region_id = var.create_listener ? alicloud_gwlb_listener.listener[0].region_id : null
    }
  }
}