output "cluster_fqdn" {
  value = yandex_mdb_postgresql_cluster.pg-cluster.host[0].fqdn
}