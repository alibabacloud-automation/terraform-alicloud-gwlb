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
    vpc_id  = "vpc-xxxxxxxxx"
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
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-gwlb/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.234.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.234.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_gwlb_listener.listener](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/gwlb_listener) | resource |
| [alicloud_gwlb_load_balancer.load_balancer](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/gwlb_load_balancer) | resource |
| [alicloud_gwlb_server_group.server_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/gwlb_server_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_listener"></a> [create\_listener](#input\_create\_listener) | Whether to create a new GWLB listener. | `bool` | `true` | no |
| <a name="input_create_load_balancer"></a> [create\_load\_balancer](#input\_create\_load\_balancer) | Whether to create a new GWLB load balancer. If false, an existing load balancer ID must be provided. | `bool` | `true` | no |
| <a name="input_create_server_group"></a> [create\_server\_group](#input\_create\_server\_group) | Whether to create a new GWLB server group. If false, an existing server group ID must be provided. | `bool` | `true` | no |
| <a name="input_listener_config"></a> [listener\_config](#input\_listener\_config) | Configuration for the GWLB listener. | <pre>object({<br/>    listener_description = optional(string, "GWLB listener created by Terraform")<br/>    dry_run              = optional(bool, false)<br/>    tags                 = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_load_balancer_config"></a> [load\_balancer\_config](#input\_load\_balancer\_config) | Configuration for the GWLB load balancer. The attributes 'vpc\_id' and 'zone\_mappings' are required and must be provided by the user. | <pre>object({<br/>    vpc_id             = string<br/>    load_balancer_name = optional(string, "gwlb-load-balancer")<br/>    address_ip_version = optional(string, "Ipv4")<br/>    resource_group_id  = optional(string, null)<br/>    dry_run            = optional(bool, false)<br/>    tags               = optional(map(string), {})<br/>    zone_mappings = list(object({<br/>      vswitch_id = string<br/>      zone_id    = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_load_balancer_id"></a> [load\_balancer\_id](#input\_load\_balancer\_id) | The ID of an existing GWLB load balancer. Required when create\_load\_balancer is false. | `string` | `null` | no |
| <a name="input_server_group_config"></a> [server\_group\_config](#input\_server\_group\_config) | Configuration for the GWLB server group. The attributes 'vpc\_id' and 'servers' are required and must be provided by the user. | <pre>object({<br/>    vpc_id            = string<br/>    server_group_name = optional(string, "gwlb-server-group")<br/>    server_group_type = optional(string, "Instance")<br/>    protocol          = optional(string, "GENEVE")<br/>    scheduler         = optional(string, "5TCH")<br/>    resource_group_id = optional(string, null)<br/>    dry_run           = optional(bool, false)<br/>    tags              = optional(map(string), {})<br/>    servers = list(object({<br/>      server_id   = string<br/>      server_type = string<br/>      server_ip   = optional(string, null)<br/>    }))<br/>    health_check_config = optional(object({<br/>      health_check_enabled         = optional(bool, true)<br/>      health_check_protocol        = optional(string, "HTTP")<br/>      health_check_connect_port    = optional(number, 80)<br/>      health_check_connect_timeout = optional(number, 5)<br/>      health_check_domain          = optional(string, "www.domain.com")<br/>      health_check_http_code       = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])<br/>      health_check_interval        = optional(number, 10)<br/>      health_check_path            = optional(string, "/health-check")<br/>      healthy_threshold            = optional(number, 2)<br/>      unhealthy_threshold          = optional(number, 2)<br/>    }), {})<br/>    connection_drain_config = optional(object({<br/>      connection_drain_enabled = optional(bool, true)<br/>      connection_drain_timeout = optional(number, 300)<br/>    }), {})<br/>  })</pre> | n/a | yes |
| <a name="input_server_group_id"></a> [server\_group\_id](#input\_server\_group\_id) | The ID of an existing GWLB server group. Required when create\_server\_group is false. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gwlb_complete_setup"></a> [gwlb\_complete\_setup](#output\_gwlb\_complete\_setup) | Complete GWLB setup information including load balancer, server group, and listener |
| <a name="output_gwlb_listener_id"></a> [gwlb\_listener\_id](#output\_gwlb\_listener\_id) | The ID of the GWLB listener |
| <a name="output_gwlb_listener_region_id"></a> [gwlb\_listener\_region\_id](#output\_gwlb\_listener\_region\_id) | The region ID of the GWLB listener |
| <a name="output_gwlb_listener_status"></a> [gwlb\_listener\_status](#output\_gwlb\_listener\_status) | The status of the GWLB listener |
| <a name="output_gwlb_load_balancer_create_time"></a> [gwlb\_load\_balancer\_create\_time](#output\_gwlb\_load\_balancer\_create\_time) | The creation time of the GWLB load balancer |
| <a name="output_gwlb_load_balancer_id"></a> [gwlb\_load\_balancer\_id](#output\_gwlb\_load\_balancer\_id) | The ID of the GWLB load balancer |
| <a name="output_gwlb_load_balancer_name"></a> [gwlb\_load\_balancer\_name](#output\_gwlb\_load\_balancer\_name) | The name of the GWLB load balancer |
| <a name="output_gwlb_load_balancer_status"></a> [gwlb\_load\_balancer\_status](#output\_gwlb\_load\_balancer\_status) | The status of the GWLB load balancer |
| <a name="output_gwlb_load_balancer_zone_mappings"></a> [gwlb\_load\_balancer\_zone\_mappings](#output\_gwlb\_load\_balancer\_zone\_mappings) | The zone mappings of the GWLB load balancer with load balancer addresses |
| <a name="output_gwlb_server_group_create_time"></a> [gwlb\_server\_group\_create\_time](#output\_gwlb\_server\_group\_create\_time) | The creation time of the GWLB server group |
| <a name="output_gwlb_server_group_id"></a> [gwlb\_server\_group\_id](#output\_gwlb\_server\_group\_id) | The ID of the GWLB server group |
| <a name="output_gwlb_server_group_name"></a> [gwlb\_server\_group\_name](#output\_gwlb\_server\_group\_name) | The name of the GWLB server group |
| <a name="output_gwlb_server_group_servers"></a> [gwlb\_server\_group\_servers](#output\_gwlb\_server\_group\_servers) | The servers in the GWLB server group with their status |
| <a name="output_gwlb_server_group_status"></a> [gwlb\_server\_group\_status](#output\_gwlb\_server\_group\_status) | The status of the GWLB server group |
| <a name="output_gwlb_server_group_type"></a> [gwlb\_server\_group\_type](#output\_gwlb\_server\_group\_type) | The type of the GWLB server group |
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