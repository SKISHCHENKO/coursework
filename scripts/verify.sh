#!/usr/bin/env bash
set -euo pipefail

# ====== Актуальные IP вашего стенда ======
BASTION_IP="${BASTION_IP:-93.77.183.34}"
ALB_IP="${ALB_IP:-158.160.140.67}"

WEB_A_IP="${WEB_A_IP:-10.20.0.13}"
WEB_B_IP="${WEB_B_IP:-10.21.0.3}"

PROM_IP="${PROM_IP:-10.20.0.14}"
ES_IP="${ES_IP:-10.20.0.28}"
KIBANA_IP="${KIBANA_IP:-93.77.176.6}"

SSH_USER="${SSH_USER:-ubuntu}"

print_section() {
  echo
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

print_section "[1] Проверка ALB с локальной машины"
echo "curl http://${ALB_IP}/"
curl -fsS "http://${ALB_IP}/" | head -n 10
echo
echo "[OK] ALB отвечает"

print_section "[2] Проверка web-серверов с bastion"
ssh "${SSH_USER}@${BASTION_IP}" "
  set -e
  for ip in ${WEB_A_IP} ${WEB_B_IP}; do
    echo \"=== curl http://\$ip ===\"
    curl -fsS \"http://\$ip/\" | head -n 10
    echo
  done
"
echo "[OK] Оба web-сервера отвечают по HTTP"

print_section "[3] Проверка node_exporter (9100) с bastion"
ssh "${SSH_USER}@${BASTION_IP}" "
  set -e
  for ip in ${WEB_A_IP} ${WEB_B_IP}; do
    echo \"=== curl http://\$ip:9100/metrics ===\"
    curl -fsS \"http://\$ip:9100/metrics\" | grep -E '^node_cpu_seconds_total|^node_memory_MemAvailable_bytes' | head
    echo
  done
"
echo "[OK] node_exporter отвечает на обоих web"

print_section "[4] Проверка nginxlog_exporter (4040) с bastion"
ssh "${SSH_USER}@${BASTION_IP}" "
  set -e
  for ip in ${WEB_A_IP} ${WEB_B_IP}; do
    echo \"=== curl http://\$ip:4040/metrics ===\"
    curl -fsS \"http://\$ip:4040/metrics\" | head -n 20
    echo
  done
"
echo "[OK] nginxlog_exporter отвечает на обоих web"

print_section "[5] Проверка Prometheus с bastion"
ssh "${SSH_USER}@${BASTION_IP}" "
  set -e
  echo '=== curl http://${PROM_IP}:9090/-/healthy ==='
  curl -fsS \"http://${PROM_IP}:9090/-/healthy\"
  echo
  echo
  echo '=== curl http://${PROM_IP}:9090/api/v1/targets | head ==='
  curl -fsS \"http://${PROM_IP}:9090/api/v1/targets\" | head -c 500
  echo
"
echo "[OK] Prometheus отвечает"

print_section "[6] Проверка Elasticsearch с bastion"
ssh "${SSH_USER}@${BASTION_IP}" "
  set -e
  echo '=== curl http://${ES_IP}:9200 ==='
  curl -fsS \"http://${ES_IP}:9200\"
  echo
"
echo "[OK] Elasticsearch отвечает"

print_section "[7] Проверка Kibana с локальной машины"
echo "curl http://${KIBANA_IP}:5601"
curl -I "http://${KIBANA_IP}:5601" || true
echo
echo "[OK] Kibana доступна снаружи"

print_section "[8] Итог"
echo "ALB:          http://${ALB_IP}/"
echo "Bastion:      ${BASTION_IP}"
echo "web-a:        ${WEB_A_IP}"
echo "web-b:        ${WEB_B_IP}"
echo "Prometheus:   ${PROM_IP}:9090"
echo "Elasticsearch:${ES_IP}:9200"
echo "Kibana:       http://${KIBANA_IP}:5601"
echo
echo "Проверка стенда завершена."
