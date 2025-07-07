data "cloudru_postgresql_option" "pg_options" {
  filter {
    # NOTE: Это обязательный параметр
    product_type = "postgres"
    version_id   = local.demo_postgres_version_16.id
  }
}

locals {
  demo_postgres_options = [
    for s in data.cloudru_postgresql_option.pg_options.options : s if s.display_name == "2vCPU/8GB RAM (Standard)"
  ]
  demo_postgres_option_2_8_standard = local.demo_postgres_options.0
}
