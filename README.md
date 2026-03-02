# Курсовая: отказоустойчивая инфраструктура сайта в Yandex Cloud (Terraform + Ansible)

Репозиторий содержит:
- **terraform/** — создание VPC, подсетей, security groups, ВМ (web/prometheus/grafana/elasticsearch/kibana/bastion), Application Load Balancer, snapshot schedules.
- **ansible/** — установка и конфигурация nginx, exporters, Prometheus, Grafana, Elasticsearch, Kibana, Filebeat.
- **docs/** — схема сети/портов и чек-лист проверки.



## Быстрый старт 

1) Terraform:
```bash
cd terraform
terraform init
terraform apply
```

2) Ansible:
```bash
cd ansible
ansible-playbook -i inventory.ini site.yml
```

3) Проверки:
- Сайт: `curl -v http://<ALB_PUBLIC_IP>/`
- Grafana: `http://<GRAFANA_PUBLIC_IP>:3000`
- Kibana: `http://<KIBANA_PUBLIC_IP>:5601`
- Prometheus targets: `http://<PROMETHEUS_PRIVATE_IP>:9090/targets` (обычно через bastion/туннель)

## Структура
Смотрите дерево проекта в папке **docs/**.
