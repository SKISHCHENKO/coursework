# Снапшоты: ежедневные, хранить 7 дней
# Примените к дискам всех ВМ.

resource "yandex_compute_snapshot_schedule" "daily" {
  name = "${local.name_prefix}-daily-snapshots"

  schedule_policy {
    expression = "0 3 * * *"
  }

  retention_period = "168h" # 7 дней

  snapshot_spec {
    description = "Daily snapshots, keep 7 days"
  }

  disk_ids = concat(
    [
      yandex_compute_instance.bastion.boot_disk[0].disk_id,
      yandex_compute_instance.prometheus.boot_disk[0].disk_id,
      yandex_compute_instance.grafana.boot_disk[0].disk_id,
      yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
      yandex_compute_instance.kibana.boot_disk[0].disk_id
    ],
    [for inst in values(yandex_compute_instance.web) : inst.boot_disk[0].disk_id]
  )
}
