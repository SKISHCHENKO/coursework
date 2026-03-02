# Чек-лист сдачи

## Сайт
- [ ] 2 ВМ web в разных зонах (A/B)
- [ ] На обеих nginx + одинаковый контент
- [ ] ALB настроен, healthcheck `/` на 80
- [ ] `curl -v http://<ALB_PUBLIC_IP>/` возвращает 200
- [ ] При остановке nginx на одном web, сайт продолжает открываться

## Мониторинг
- [ ] Prometheus собирает метрики node_exporter + nginxlog_exporter с web
- [ ] Grafana подключена к Prometheus
- [ ] Есть дашборды: CPU/RAM/Disk/Net + http_response_count_total + http_response_size_bytes
- [ ] Выставлены thresholds

## Логи
- [ ] Elasticsearch поднят
- [ ] Filebeat на web отправляет access.log/error.log
- [ ] Kibana подключена к Elasticsearch и видит логи

## Сеть
- [ ] VPC одна, web/prometheus/elasticsearch — приватные
- [ ] grafana/kibana/alb — публичные
- [ ] bastion — публичный, открыт только 22
- [ ] SG настроены по принципу минимальных прав

## Бэкапы
- [ ] Snapshot schedule для дисков всех ВМ
- [ ] Ежедневно, хранение 7 дней
