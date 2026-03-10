terraform {
  required_version = ">= 1.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.234.0"
    }
  }
}

provider "alicloud" {
  region = "cn-wulanchabu"
}