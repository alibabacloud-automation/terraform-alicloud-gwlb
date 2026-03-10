阿里云网关负载均衡器 (GWLB) Terraform 模块

# terraform-alicloud-gwlb

[English](https://github.com/alibabacloud-automation/terraform-alicloud-gwlb/blob/main/README.md) | 简体中文

在阿里云上创建网关负载均衡器 (GWLB) 资源的 Terraform 模块。此模块提供了部署 GWLB 基础设施的综合解决方案，包括负载均衡器、服务器组和监听器组件。GWLB 专为高性能网络流量分发而设计，非常适合需要透明流量转发和高级负载均衡功能的场景。有关阿里云 GWLB 服务的更多信息，请参阅[网关负载均衡器文档](https://www.alibabacloud.com/help/en/slb/gateway-based-load-balancing-gwlb)。

## 使用方法

使用此模块创建完整的 GWLB 设置：

```terraform
data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

data "alicloud_resource_manager_resource_groups" "default" {}

module "gwlb" {
  source = "alibabacloud-automation/gwlb/alicloud"
  
  # 负载均衡器配置
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
  
  # 服务器组配置
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
  
  # 监听器配置
  listener_config = {
    listener_description = "GWLB listener for production"
  }
  
  # 通用标签
  common_tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-gwlb/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)