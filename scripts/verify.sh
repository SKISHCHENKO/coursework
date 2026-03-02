#!/usr/bin/env bash
set -euo pipefail

echo "[*] Проверка доступности вебов по HTTP (из bastion/вашей машины с доступом в приватную сеть)"
for ip in "${WEB_IPS[@]:-}"; do
  echo " - curl http://$ip/"
  curl -fsS "http://$ip/" | head -n 3
done

echo "[*] Проверка ALB (укажите ALB_IP переменной окружения)"
if [[ -n "${ALB_IP:-}" ]]; then
  curl -v "http://${ALB_IP}/" -o /dev/null
else
  echo "ALB_IP не задан. Пример: ALB_IP=1.2.3.4 ./scripts/verify.sh"
fi

echo "[*] Проверка exporters (node_exporter 9100, nginxlog_exporter 4040) — укажите WEB_IPS массивом"
echo "Пример:"
echo '  WEB_IPS=(10.0.0.10 10.0.0.11) ./scripts/verify.sh'
