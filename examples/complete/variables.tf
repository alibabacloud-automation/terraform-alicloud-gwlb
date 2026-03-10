# Variables for GWLB complete example

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "gwlb-example-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "vswitch_configs" {
  description = "Configuration for VSwitches. Using cn-wulanchabu region which supports GWLB service."
  type = list(object({
    name       = string
    cidr_block = string
    zone_id    = string
  }))
  default = [
    {
      name       = "gwlb-example-vswitch-1"
      cidr_block = "172.16.1.0/24"
      zone_id    = "cn-wulanchabu-b"
    },
    {
      name       = "gwlb-example-vswitch-2"
      cidr_block = "172.16.2.0/24"
      zone_id    = "cn-wulanchabu-c"
    }
  ]
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "gwlb-example-sg"
}

variable "security_group_rules" {
  description = "Security group rules for the example"
  type = map(object({
    type        = string
    ip_protocol = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  }))
  default = {
    "allow_http" = {
      type        = "ingress"
      ip_protocol = "tcp"
      policy      = "accept"
      port_range  = "80/80"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
    "allow_https" = {
      type        = "ingress"
      ip_protocol = "tcp"
      policy      = "accept"
      port_range  = "443/443"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

variable "instance_count" {
  description = "Number of ECS instances to create as backend servers"
  type        = number
  default     = 3
}

variable "instance_name_prefix" {
  description = "Prefix for ECS instance names"
  type        = string
  default     = "gwlb-backend"
}

variable "gwlb_name" {
  description = "Name of the GWLB load balancer"
  type        = string
  default     = "gwlb-example"
}

variable "server_group_name" {
  description = "Name of the GWLB server group"
  type        = string
  default     = "gwlb-example-sg"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "example"
    Purpose     = "gwlb-demo"
    ManagedBy   = "terraform"
  }
}