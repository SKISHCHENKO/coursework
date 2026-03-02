variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "default_zone" {
  type        = string
  description = "Зона по умолчанию (для ресурсов без явной зоны)"
  default     = "ru-central1-a"
}

variable "zones" {
  type        = list(string)
  description = "Зоны для web (минимум две)"
  default     = ["ru-central1-a", "ru-central1-b"]
}

variable "vpc_name" {
  type        = string
  default     = "ha-vpc"
}

variable "public_cidr" {
  type        = string
  default     = "10.10.0.0/24"
}

variable "private_cidrs" {
  type        = map(string)
  description = "CIDR приватных подсетей по зонам"
  default = {
    "ru-central1-a" = "10.20.0.0/24"
    "ru-central1-b" = "10.21.0.0/24"
  }
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  type        = string
  description = "Ваш публичный SSH ключ (строкой). Пример: содержимое ~/.ssh/id_rsa.pub"
}

variable "image_id" {
  type        = string
  description = "ID образа (Ubuntu 22.04 / Jammy). Можно взять из каталога YC."
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_resources" {
  description = "Ресурсы ВМ (настраивайте под сервисы)"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 4
  }
}

variable "disk_size_gb" {
  type    = number
  default = 20
}

variable "allowed_admin_cidr" {
  type        = string
  description = "Ваш внешний IP/подсеть для доступа к bastion/grafana/kibana (например, 1.2.3.4/32)"
}

# Порты (можете поменять под свои exporters)
variable "node_exporter_port" { type = number, default = 9100 }
variable "nginxlog_exporter_port" { type = number, default = 4040 }
