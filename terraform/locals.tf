locals {
  name_prefix = "course-ha"
  web_names   = [for i, z in var.zones : "web-${replace(z, "ru-central1-", "")}"]
}
