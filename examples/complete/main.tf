# Complete example for GWLB Module
# This example demonstrates how to create a complete GWLB setup including VPC, VSwitches, ECS instances, and GWLB resources


data "alicloud_resource_manager_resource_groups" "default" {}

data "alicloud_images" "default" {
  name_regex = "^ubuntu_18.*64"
  owners     = "system"
}

data "alicloud_instance_types" "default" {
  availability_zone = "cn-wulanchabu-b"
  cpu_core_count    = 2
  memory_size       = 4
}

# Use existing VPC or create new one
data "alicloud_vpcs" "existing" {
  name_regex = "^test-vpc-wulanchabu$"
}

resource "alicloud_vpc" "example" {
  count = length(data.alicloud_vpcs.existing.ids) == 0 ? 1 : 0

  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

locals {
  vpc_id = length(data.alicloud_vpcs.existing.ids) > 0 ? data.alicloud_vpcs.existing.ids[0] : alicloud_vpc.example[0].id
}

# Create VSwitches in different zones
resource "alicloud_vswitch" "example" {
  count = length(var.vswitch_configs)

  vpc_id       = local.vpc_id
  cidr_block   = var.vswitch_configs[count.index].cidr_block
  zone_id      = var.vswitch_configs[count.index].zone_id
  vswitch_name = var.vswitch_configs[count.index].name
  tags         = var.tags
}

# Create security group
resource "alicloud_security_group" "example" {
  security_group_name = var.security_group_name
  description         = "Security group for GWLB example"
  vpc_id              = local.vpc_id
  tags                = var.tags
}

# Create security group rules
resource "alicloud_security_group_rule" "ingress" {
  for_each = var.security_group_rules

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.example.id
  cidr_ip           = each.value.cidr_ip
}

# Create ECS instances as backend servers
resource "alicloud_instance" "example" {
  count = var.instance_count

  availability_zone    = alicloud_vswitch.example[count.index % length(alicloud_vswitch.example)].zone_id
  security_groups      = [alicloud_security_group.example.id]
  instance_type        = data.alicloud_instance_types.default.instance_types[0].id
  system_disk_category = "cloud_efficiency"
  system_disk_size     = 20
  image_id             = data.alicloud_images.default.images[0].id
  instance_name        = format("%s-%02d", var.instance_name_prefix, count.index + 1)
  vswitch_id           = alicloud_vswitch.example[count.index % length(alicloud_vswitch.example)].id
  tags                 = var.tags
}

# Call the GWLB module
module "gwlb" {
  source = "../../"

  # Load balancer configuration
  load_balancer_config = {
    vpc_id             = local.vpc_id
    load_balancer_name = var.gwlb_name
    address_ip_version = "Ipv4"
    resource_group_id  = data.alicloud_resource_manager_resource_groups.default.ids[0]
    zone_mappings = [
      for i, vswitch in alicloud_vswitch.example : {
        vswitch_id = vswitch.id
        zone_id    = vswitch.zone_id
      }
    ]
  }

  # Server group configuration
  server_group_config = {
    vpc_id            = local.vpc_id
    server_group_name = var.server_group_name
    server_group_type = "Instance"
    protocol          = "GENEVE"
    scheduler         = "5TCH"
    resource_group_id = data.alicloud_resource_manager_resource_groups.default.ids[0]
    servers = [
      for instance in alicloud_instance.example : {
        server_id   = instance.id
        server_type = "Ecs"
      }
    ]
    health_check_config = {
      health_check_enabled         = true
      health_check_protocol        = "HTTP"
      health_check_connect_port    = 80
      health_check_connect_timeout = 5
      health_check_domain          = "www.example.com"
      health_check_http_code       = ["http_2xx", "http_3xx"]
      health_check_interval        = 10
      health_check_path            = "/health"
      healthy_threshold            = 2
      unhealthy_threshold          = 2
    }
    connection_drain_config = {
      connection_drain_enabled = true
      connection_drain_timeout = 300
    }
  }

  # Listener configuration
  listener_config = {
    listener_description = "gwlb-listener-example"
  }
}