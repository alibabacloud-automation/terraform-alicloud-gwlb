Alicloud Gateway Load Balancer (GWLB) Terraform Module

# terraform-alicloud-gwlb

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-gwlb/blob/main/README-CN.md)

Terraform module which creates Gateway Load Balancer (GWLB) resources on Alibaba Cloud. This module provides a comprehensive solution for deploying GWLB infrastructure including load balancer, server group, and listener components. GWLB is designed for high-performance network traffic distribution and is ideal for scenarios requiring transparent traffic forwarding and advanced load balancing capabilities. For more information about Alibaba Cloud GWLB service, please refer to the [Gateway Load Balancer documentation](https://www.alibabacloud.com/help/en/slb/gateway-based-load-balancing-gwlb).

## Usage

To use this module to create a complete GWLB setup:

```terraform
data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

data "alicloud_resource_manager_resource_groups" "default" {}

module "gwlb" {
  source = "alibabacloud-automation/gwlb/alicloud"
  
  # Load balancer configuration
  load_balancer_config = {
    vpc_id             = "vpc-xxxxxxxxx"
    load_balancer_name = "my-gwlb"
    address_ip_version = "Ipv4"
    resource_group_id  = data.alicloud_resource_manager_resource_groups.default.ids[0]
    zone_mappings = [
      {
        vswitch_id = "vsw-xxxxxxxxx"
        zone_id    = data.alicloud_zones.default.zones[0].id
      },
      {
        vswitch_id = "vsw-yyyyyyyyy"
        zone_id    = data.alicloud_zones.default.zones[1].id
      }
    ]
  }
  
  # Server group configuration
  server_group_config = {
    vpc_id            = "vpc-xxxxxxxxx"
    server_group_name = "my-gwlb-server-group"
    server_group_type = "Instance"
    protocol          = "GENEVE"
    scheduler         = "5TCH"
    servers = [
      {
        server_id   = "i-xxxxxxxxx"
        server_type = "Ecs"
      },
      {
        server_id   = "i-yyyyyyyyy"
        server_type = "Ecs"
      }
    ]
    health_check_config = {
      health_check_enabled         = true
      health_check_protocol        = "HTTP"
      health_check_connect_port    = 80
      health_check_path            = "/health"
    }
  }
  
  # Listener configuration
  listener_config = {
    listener_description = "GWLB listener for production"
  }
  
  # Common tags
  common_tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-gwlb/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)