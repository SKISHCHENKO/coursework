# Курсовая: отказоустойчивая инфраструктура сайта в Yandex Cloud (Terraform + Ansible)

Репозиторий содержит:
- **terraform/** — создание VPC, подсетей, security groups, ВМ (web/prometheus/grafana/elasticsearch/kibana/bastion), Application Load Balancer, snapshot schedules.
- **ansible/** — установка и конфигурация nginx, exporters, Prometheus, Grafana, Elasticsearch, Kibana, Filebeat.
- **docs/** — схема сети/портов и чек-лист проверки.



## Быстрый старт 

1) Terraform:
```bash
cd terraform
terraform fmt
terraform init
terraform plan
terraform apply
```

2) Ansible:
```bash
cd ansible
ansible-playbook -i inventory.ini site.yml
```

3) Проверки:
Сделаны через скрипт ~/projects/netology/coursework/scripts/verify.sh

## Структура
Смотрите дерево проекта в папке **docs/**.


Коды и критическая информация вынесена в скрипт с переменными окружения:
![Начало](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen1_0.png)

Запуск терраформа:
![Терраформ](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen1_1.png)

Успешный запуск терраформа с указанием IP
![Терраформ](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen1_2.png)

Запуск ansible
![Ansible](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen1_3.png)

В YandexCloud появилась сети с подсетями и ВМ:
![YandexCloud](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen2_1.jpg)

![YandexCloud](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen2_2.jpg)

![YandexCloud](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen2_3.jpg)

Сайт по указанному адресу открывается в броузере:

![YandexCloud](https://github.com/SKISHCHENKO/coursework/blob/main/img/screen2_4.jpg)