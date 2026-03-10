# Variable definitions for GWLB Module

# Resource creation control variables
variable "create_load_balancer" {
  description = "Whether to create a new GWLB load balancer. If false, an existing load balancer ID must be provided."
  type        = bool
  default     = true
}

variable "create_server_group" {
  description = "Whether to create a new GWLB server group. If false, an existing server group ID must be provided."
  type        = bool
  default     = true
}

variable "create_listener" {
  description = "Whether to create a new GWLB listener."
  type        = bool
  default     = true
}

# External resource IDs (when create_* = false)
variable "load_balancer_id" {
  description = "The ID of an existing GWLB load balancer. Required when create_load_balancer is false."
  type        = string
  default     = null
}

variable "server_group_id" {
  description = "The ID of an existing GWLB server group. Required when create_server_group is false."
  type        = string
  default     = null
}

# GWLB Load Balancer configuration
variable "load_balancer_config" {
  description = "Configuration for the GWLB load balancer. The attributes 'vpc_id' and 'zone_mappings' are required and must be provided by the user."
  type = object({
    vpc_id             = string
    load_balancer_name = optional(string, "gwlb-load-balancer")
    address_ip_version = optional(string, "Ipv4")
    resource_group_id  = optional(string, null)
    dry_run            = optional(bool, false)
    tags               = optional(map(string), {})
    zone_mappings = list(object({
      vswitch_id = string
      zone_id    = string
    }))
  })
}

# GWLB Server Group configuration
variable "server_group_config" {
  description = "Configuration for the GWLB server group. The attributes 'vpc_id' and 'servers' are required and must be provided by the user."
  type = object({
    vpc_id            = string
    server_group_name = optional(string, "gwlb-server-group")
    server_group_type = optional(string, "Instance")
    protocol          = optional(string, "GENEVE")
    scheduler         = optional(string, "5TCH")
    resource_group_id = optional(string, null)
    dry_run           = optional(bool, false)
    tags              = optional(map(string), {})
    servers = list(object({
      server_id   = string
      server_type = string
      server_ip   = optional(string, null)
    }))
    health_check_config = optional(object({
      health_check_enabled         = optional(bool, true)
      health_check_protocol        = optional(string, "HTTP")
      health_check_connect_port    = optional(number, 80)
      health_check_connect_timeout = optional(number, 5)
      health_check_domain          = optional(string, "www.domain.com")
      health_check_http_code       = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])
      health_check_interval        = optional(number, 10)
      health_check_path            = optional(string, "/health-check")
      healthy_threshold            = optional(number, 2)
      unhealthy_threshold          = optional(number, 2)
    }), {})
    connection_drain_config = optional(object({
      connection_drain_enabled = optional(bool, true)
      connection_drain_timeout = optional(number, 300)
    }), {})
  })
}

# GWLB Listener configuration
variable "listener_config" {
  description = "Configuration for the GWLB listener."
  type = object({
    listener_description = optional(string, "GWLB listener created by Terraform")
    dry_run              = optional(bool, false)
    tags                 = optional(map(string), {})
  })
  default = {}
}