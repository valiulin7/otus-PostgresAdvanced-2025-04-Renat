terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.140"
}



provider "yandex" {
  folder_id = var.yc_folder_id
  token = var.yc_token
  cloud_id = var.yc_cloud_id
  zone = var.yc_region
}