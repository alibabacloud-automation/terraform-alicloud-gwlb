# Gateway Load Balancer (GWLB) Module Main Configuration
# This module creates a complete GWLB setup including load balancer, server group, and listener

# GWLB Load Balancer
resource "alicloud_gwlb_load_balancer" "load_balancer" {
  count = var.create_load_balancer ? 1 : 0

  vpc_id             = var.load_balancer_config.vpc_id
  load_balancer_name = var.load_balancer_config.load_balancer_name
  address_ip_version = var.load_balancer_config.address_ip_version
  resource_group_id  = var.load_balancer_config.resource_group_id
  dry_run            = var.load_balancer_config.dry_run
  tags               = var.load_balancer_config.tags

  dynamic "zone_mappings" {
    for_each = var.load_balancer_config.zone_mappings
    content {
      vswitch_id = zone_mappings.value.vswitch_id
      zone_id    = zone_mappings.value.zone_id
    }
  }
}

# GWLB Server Group
resource "alicloud_gwlb_server_group" "server_group" {
  count = var.create_server_group ? 1 : 0

  vpc_id            = var.server_group_config.vpc_id
  server_group_name = var.server_group_config.server_group_name
  server_group_type = var.server_group_config.server_group_type
  protocol          = var.server_group_config.protocol
  scheduler         = var.server_group_config.scheduler
  resource_group_id = var.server_group_config.resource_group_id
  dry_run           = var.server_group_config.dry_run
  tags              = var.server_group_config.tags

  dynamic "servers" {
    for_each = var.server_group_config.servers
    content {
      server_id   = servers.value.server_id
      server_type = servers.value.server_type
      server_ip   = servers.value.server_ip
    }
  }

  health_check_config {
    health_check_enabled         = var.server_group_config.health_check_config.health_check_enabled
    health_check_protocol        = var.server_group_config.health_check_config.health_check_protocol
    health_check_connect_port    = var.server_group_config.health_check_config.health_check_connect_port
    health_check_connect_timeout = var.server_group_config.health_check_config.health_check_connect_timeout
    health_check_domain          = var.server_group_config.health_check_config.health_check_domain
    health_check_http_code       = var.server_group_config.health_check_config.health_check_http_code
    health_check_interval        = var.server_group_config.health_check_config.health_check_interval
    health_check_path            = var.server_group_config.health_check_config.health_check_path
    healthy_threshold            = var.server_group_config.health_check_config.healthy_threshold
    unhealthy_threshold          = var.server_group_config.health_check_config.unhealthy_threshold
  }

  connection_drain_config {
    connection_drain_enabled = var.server_group_config.connection_drain_config.connection_drain_enabled
    connection_drain_timeout = var.server_group_config.connection_drain_config.connection_drain_timeout
  }
}

# GWLB Listener
resource "alicloud_gwlb_listener" "listener" {
  count = var.create_listener ? 1 : 0

  load_balancer_id     = var.create_load_balancer ? alicloud_gwlb_load_balancer.load_balancer[0].id : var.load_balancer_id
  server_group_id      = var.create_server_group ? alicloud_gwlb_server_group.server_group[0].id : var.server_group_id
  listener_description = var.listener_config.listener_description
  dry_run              = var.listener_config.dry_run
  tags                 = var.listener_config.tags
}