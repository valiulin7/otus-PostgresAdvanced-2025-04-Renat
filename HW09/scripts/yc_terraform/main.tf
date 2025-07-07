resource "yandex_vpc_network" "tf-demo-net1" {
  name = "tf-demo-net"
}

resource "yandex_vpc_subnet" "demo-subnet-1" {
  name           = "demo-subnet-zone-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.tf-demo-net1.id
  v4_cidr_blocks = ["172.16.40.0/24"]
  depends_on = [yandex_vpc_network.tf-demo-net1]
}


resource "yandex_mdb_postgresql_cluster" "pg-cluster" {
  name = "test"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.tf-demo-net1.id

  host {
    zone      = var.yc_region
    subnet_id = yandex_vpc_subnet.demo-subnet-1.id
  }

  config {
    version = 17
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
    postgresql_config = {
      max_connections                = 395
      enable_parallel_hash           = true
      autovacuum_vacuum_scale_factor = 0.34
      default_transaction_isolation  = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries       = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }
}

resource "yandex_mdb_postgresql_database" "otus" {
  cluster_id = yandex_mdb_postgresql_cluster.pg-cluster.id
  name       = var.psql_db
  owner      = yandex_mdb_postgresql_user.otus-psql-user.name
  lc_collate = "ru_RU.UTF-8"
  lc_type   = "ru_RU.UTF-8"
}

resource "yandex_mdb_postgresql_user" "otus-psql-user" {
  cluster_id = yandex_mdb_postgresql_cluster.pg-cluster.id
  name       = var.psql_user
  password   = var.psql_pass
}

