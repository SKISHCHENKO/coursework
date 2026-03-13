#!/usr/bin/env bash
set -euo pipefail

INV="${INV:-$HOME/projects/netology/coursework/ansible/inventory.ini}"
ALB_IP="${ALB_IP:-158.160.140.67}"
KIBANA_IP="${KIBANA_IP:-93.77.176.6}"

section() {
  echo
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

section "[1] Проверка ALB с локальной машины"
echo "curl http://${ALB_IP}/"
curl -fsS "http://${ALB_IP}/" | head -n 10
echo
echo "[OK] ALB отвечает"

section "[2] Проверка nginx локально на web-хостах через Ansible"
ansible web -i "$INV" -m shell -a \
"bash -o pipefail -c 'curl -fsS http://127.0.0.1/ | head -n 10'"
echo
echo "[OK] nginx отвечает на web-a и web-b"

section "[3] Проверка node_exporter локально на web-хостах"
ansible web -i "$INV" -m shell -a \
"bash -o pipefail -c 'curl -fsS http://127.0.0.1:9100/metrics | grep -E \"^node_cpu_seconds_total|^node_memory_MemAvailable_bytes\" | head'"
echo
echo "[OK] node_exporter отвечает на web-a и web-b"

section "[4] Проверка nginxlog_exporter локально на web-хостах"
ansible web -i "$INV" -m shell -a \
"bash -o pipefail -c 'curl -fsS http://127.0.0.1:4040/metrics | head -n 20'"
echo
echo "[OK] nginxlog_exporter отвечает на web-a и web-b"

section "[5] Проверка Prometheus локально на prom-host"
ansible prometheus -i "$INV" -m shell -a \
"bash -o pipefail -c 'curl -fsS http://127.0.0.1:9090/-/healthy && echo && curl -fsS http://127.0.0.1:9090/api/v1/targets | head -c 1000 && echo'"
echo
echo "[OK] Prometheus отвечает"

section "[6] Проверка Elasticsearch локально на es-host"
ansible elasticsearch -i "$INV" -m shell -a \
"bash -o pipefail -c 'curl -fsS http://127.0.0.1:9200 && echo'"
echo
echo "[OK] Elasticsearch отвечает"

section "[7] Проверка Kibana с локальной машины"
curl -I "http://${KIBANA_IP}:5601"
echo
echo "[OK] Kibana доступна снаружи"

section "[8] Итог"
echo "ALB:    http://${ALB_IP}/"
echo "Kibana: http://${KIBANA_IP}:5601"
echo
echo "Проверка завершена."
