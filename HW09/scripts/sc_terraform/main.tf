terraform {
  required_providers {
    cloudru = {
      source  = "cloud.ru/cloudru/cloud"
      version = "1.4.0"
    }
  }
}

provider "cloudru" {

  # NOTE: Это опциональный параметр, требуется для работы с DBaaS
  dbaas_endpoint = "dbaas.api.cloud.ru:443"

  # NOTE: Это обязательный параметр
  auth_key_id = var.auth_key_id

  # NOTE: Это обязательный параметр
  auth_secret = var.auth_key_secret
  
  iam_endpoint = "iam.api.cloud.ru:443"
  
  project_id = "6e4580dd-6424-430d-8c79-a011eb33d729"
}


variable "auth_key_id" {
  type        = string
}

variable "auth_key_secret" {
  type        = string
}