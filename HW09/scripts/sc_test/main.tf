terraform {
  required_providers {
    cloudru = {
      source  = "cloud.ru/cloudru/cloud"
      version = "1.4.0"
    }
  }
}

provider "cloudru" {

  # NOTE: Это обязательный параметр
  auth_key_id = var.auth_key_id

  # NOTE: Это обязательный параметр
  auth_secret = var.auth_key_secret
  
  iam_endpoint = "iam.api.cloud.ru:443"

  # Опционально, если нужно для DBaaS
  dbaas_endpoint = "dbaas.api.cloud.ru:443"
}

data "cloudru_postgresql_version" "pg_versions" {
  filter {
    # NOTE: Это обязательный параметр
    product_type = "postgres"
  }
}

locals {
  demo_postgres_versions = [
    for s in data.cloudru_postgresql_version.pg_versions.versions : s if s.version == "16"
  ]
  demo_postgres_version_16 = local.demo_postgres_versions.0
}

data "cloudru_postgresql_option" "pg_options" {
  filter {
    # NOTE: Это обязательный параметр
    product_type = "postgres"
    version_id   = local.demo_postgres_version_16.id
  }
}


output "all_postgres_options" {
  value = [for o in data.cloudru_postgresql_option.pg_options.options : o.display_name]
}

variable "auth_key_id" {
  default     = "8fa6b37f2a907069b1e296a72220324b"
  type        = string
}

variable "auth_key_secret" {
  default     = "434cdf81fe54570dd8e4ef7cb28bb31e"
  type        = string
}

variable "region" {
  description = "Регион"
  type        = string
  default     = "ru-1"
}

