# Порты и Security Groups (минимально необходимые)

## Внешний доступ (из интернета)
- ALB: 80/tcp (и 443/tcp если делаете HTTPS)
- Grafana: 3000/tcp (желательно ограничить по вашему IP)
- Kibana: 5601/tcp (желательно ограничить по вашему IP)
- Bastion: 22/tcp (ограничить по вашему IP)

## Внутренние связи
### Web (nginx)
- 80/tcp: **вход** только от SG балансера (ALB)
- 22/tcp: **вход** только от SG bastion
- 9100/tcp: **вход** только от SG prometheus (node_exporter)
- 4040/tcp (пример): **вход** только от SG prometheus (nginx log exporter)
- **исход**: 9200/tcp к Elasticsearch (filebeat)

### Prometheus
- 9090/tcp: доступ нужен Grafana (обычно по приватной сети)
- **исход**: к web:9100 и web:4040

### Elasticsearch
- 9200/tcp: **вход** только от web (filebeat) и kibana
- 22/tcp: **вход** только от bastion

### Kibana
- 5601/tcp: внешний доступ (или только ваш IP)
- **исход**: 9200/tcp к Elasticsearch

### Grafana
- 3000/tcp: внешний доступ (или только ваш IP)
- **исход**: 9090/tcp к Prometheus
