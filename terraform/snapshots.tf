# Снапшоты: ежедневные, хранить 7 дней
# Реализация через snapshot schedule (disk snapshot schedules).
# Примените к дискам всех ВМ.

resource "yandex_compute_snapshot_schedule" "daily" {
  name = "${local.name_prefix}-daily-snapshots"

  schedule_policy {
    expression = "0 3 * * *" # ежедневно в 03:00
  }

  retention_period = "168h" # 7 дней

  snapshot_spec {
    description = "Daily snapshots, keep 7 days"
  }
}

# Привязка к дискам (boot_disk) каждой ВМ
resource "yandex_compute_disk_snapshot_schedule_attachment" "bastion" {
  disk_id             = yandex_compute_instance.bastion.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}

resource "yandex_compute_disk_snapshot_schedule_attachment" "prometheus" {
  disk_id             = yandex_compute_instance.prometheus.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}

resource "yandex_compute_disk_snapshot_schedule_attachment" "grafana" {
  disk_id             = yandex_compute_instance.grafana.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}

resource "yandex_compute_disk_snapshot_schedule_attachment" "elasticsearch" {
  disk_id             = yandex_compute_instance.elasticsearch.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}

resource "yandex_compute_disk_snapshot_schedule_attachment" "kibana" {
  disk_id             = yandex_compute_instance.kibana.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}

resource "yandex_compute_disk_snapshot_schedule_attachment" "web" {
  for_each            = yandex_compute_instance.web
  disk_id             = each.value.boot_disk[0].disk_id
  snapshot_schedule_id = yandex_compute_snapshot_schedule.daily.id
}
