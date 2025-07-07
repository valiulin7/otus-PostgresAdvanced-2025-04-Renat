resource "cloudru_postgresql_cluster" "my-pg-cluster" {
  # название кластера.
  name = "example-postgres-cluster"
  # название продукта: postgres или timescaledb
  product_type = "postgres"
  # описание кластера.
  description = "DBaaS Evolution Postgres"
  # идентификатор подсети.
  subnet_id = "32e73ef0-dac9-48ec-b92f-0b04ad50268c"
  # название базы данных, которая будет создана в экземпляре сервиса по умолчанию
  initial_database = "mydb"
  # параметры кластера
  cluster_spec = {
    # идентификатор версии продукта
    version_id = local.demo_postgres_version_16.id
    # идентификатор опции, назначенной кластеру
    option_id = local.demo_postgres_option_2_8_standard.id
    # включает или отключает пулер соединений PgBouncer
    pooler_enabled = false
    # определяет отказоустойчивость кластера. Возможные значения:
    #  - true --- отказоустойчивая конфигурация с двумя синхронизированными узлами: основным и резервным.
    #  - false --- одноузловая конфигурация.
    primary_standby_mode = false
    # количество реплик на чтение
    replicas = 0
    # защищает от случайного удаления базы данных
    safe_delete = true
    # синхронную репликацию
    sync_replication = false

    backup = {
      enabled               = false
      retention_policy_days = 7
      schedule              = "0 3 * * *"  # пример cron-выражения для ежедневного запуска в 3:00
    }

    # параметры диска
    disk = {
      # идентификатор диска
      id = local.demo_postgres_disk_ssd.id
      # размер диска в гигабайтах
      size_gigs = 16
    }
  }
}
