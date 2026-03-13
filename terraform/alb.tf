#  ресурсы ALB в YC имеют много нюансов (адреса, backend, target group).

# Target group (включает 2 web по приватным IP)
resource "yandex_alb_target_group" "web_tg" {
  name = "${local.name_prefix}-tg-web"

  dynamic "target" {
    for_each = yandex_compute_instance.web
    content {
      subnet_id  = yandex_vpc_subnet.private[target.key].id
      ip_address = target.value.network_interface[0].ip_address
    }
  }
}

# Backend group
resource "yandex_alb_backend_group" "web_bg" {
  name = "${local.name_prefix}-bg-web"

  http_backend {
    name             = "web-http"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_tg.id]

    healthcheck {
      timeout  = "2s"
      interval = "5s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP router
resource "yandex_alb_http_router" "router" {
  name = "${local.name_prefix}-http-router"
}

resource "yandex_alb_virtual_host" "vh" {
  name           = "vh-default"
  http_router_id = yandex_alb_http_router.router.id

  route {
    name = "route-root"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
        timeout          = "3s"
      }
    }
  }
}

# Load balancer (публичный)
resource "yandex_alb_load_balancer" "alb" {
  name       = "${local.name_prefix}-alb"
  network_id = yandex_vpc_network.vpc.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "http"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.router.id
      }
    }
  }

  security_group_ids = [yandex_vpc_security_group.alb.id]
}
