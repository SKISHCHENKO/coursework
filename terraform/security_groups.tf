# Bastion SG: только SSH с админского IP
resource "yandex_vpc_security_group" "bastion" {
  name       = "${local.name_prefix}-sg-bastion"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from admin"
    v4_cidr_blocks = [var.allowed_admin_cidr]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "alb" {
  name       = "${local.name_prefix}-sg-alb"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "ALB node health checks"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress to backends"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web SG
resource "yandex_vpc_security_group" "web" {
  name       = "${local.name_prefix}-sg-web"
  network_id = yandex_vpc_network.vpc.id

  # HTTP только от ALB SG (через security_group_id)
  ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB"
    security_group_id = yandex_vpc_security_group.alb.id
    port              = 80
  }

  # SSH только от bastion SG
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion.id
    port              = 22
  }

  # node_exporter
  ingress {
    protocol          = "TCP"
    description       = "node_exporter from prometheus"
    security_group_id = yandex_vpc_security_group.prometheus.id
    port              = var.node_exporter_port
  }

  # nginxlog_exporter
  ingress {
    protocol          = "TCP"
    description       = "nginxlog_exporter from prometheus"
    security_group_id = yandex_vpc_security_group.prometheus.id
    port              = var.nginxlog_exporter_port
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress (e.g., filebeat to ES)"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Prometheus SG
resource "yandex_vpc_security_group" "prometheus" {
  name       = "${local.name_prefix}-sg-prometheus"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion.id
    port              = 22
  }

  # (опционально) открыть 9090 от grafana SG, если Prometheus UI нужен grafana-хосту
  ingress {
    protocol          = "TCP"
    description       = "Prometheus UI from grafana"
    security_group_id = yandex_vpc_security_group.grafana.id
    port              = 9090
  }

  egress {
    protocol       = "ANY"
    description    = "Allow egress to scrape exporters"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Grafana SG (публичный доступ на 3000)
resource "yandex_vpc_security_group" "grafana" {
  name       = "${local.name_prefix}-sg-grafana"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Grafana UI (лучше ограничить по IP)"
    v4_cidr_blocks = [var.allowed_admin_cidr]
    port           = 3000
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion.id
    port              = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elasticsearch SG
resource "yandex_vpc_security_group" "elasticsearch" {
  name       = "${local.name_prefix}-sg-elasticsearch"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion.id
    port              = 22
  }

  ingress {
    protocol          = "TCP"
    description       = "ES 9200 from web (filebeat) and kibana"
    security_group_id = yandex_vpc_security_group.kibana.id
    port              = 9200
  }

  # filebeat from web SG
  ingress {
    protocol          = "TCP"
    description       = "ES 9200 from web (filebeat)"
    security_group_id = yandex_vpc_security_group.web.id
    port              = 9200
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Kibana SG (публичный доступ на 5601)
resource "yandex_vpc_security_group" "kibana" {
  name       = "${local.name_prefix}-sg-kibana"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Kibana UI (лучше ограничить по IP)"
    v4_cidr_blocks = [var.allowed_admin_cidr]
    port           = 5601
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion.id
    port              = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
