resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = "${local.name_prefix}-public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.public_cidr]
}

resource "yandex_vpc_subnet" "private" {
  for_each       = var.private_cidrs
  name           = "${local.name_prefix}-private-${replace(each.key, "ru-central1-", "")}"
  zone           = each.key
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [each.value]
}
