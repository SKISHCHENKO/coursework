# Bastion (публичная)
resource "yandex_compute_instance" "bastion" {
  name        = "${local.name_prefix}-bastion"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# Web instances (приватные, по зонам)
resource "yandex_compute_instance" "web" {
  for_each    = toset(var.zones)
  name        = "${local.name_prefix}-web-${replace(each.key, "ru-central1-", "")}"
  platform_id = var.vm_platform_id
  zone        = each.key

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private[each.key].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# Prometheus (приватная, зона по умолчанию)
resource "yandex_compute_instance" "prometheus" {
  name        = "${local.name_prefix}-prometheus"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private[var.default_zone].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.prometheus.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# Grafana (публичная)
resource "yandex_compute_instance" "grafana" {
  name        = "${local.name_prefix}-grafana"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.grafana.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# Elasticsearch (приватная)
resource "yandex_compute_instance" "elasticsearch" {
  name        = "${local.name_prefix}-elasticsearch"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private[var.default_zone].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.elasticsearch.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# Kibana (публичная)
resource "yandex_compute_instance" "kibana" {
  name        = "${local.name_prefix}-kibana"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
