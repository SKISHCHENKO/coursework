# Структура репозитория

```
.
├── terraform/
│   ├── versions.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── network.tf
│   ├── security_groups.tf
│   ├── instances.tf
│   ├── alb.tf
│   ├── snapshots.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini.example
│   ├── group_vars/
│   │   └── all.yml
│   ├── site.yml
│   └── roles/
│       ├── common/
│       ├── nginx/
│       ├── node_exporter/
│       ├── nginxlog_exporter/
│       ├── prometheus/
│       ├── grafana/
│       ├── elasticsearch/
│       ├── kibana/
│       └── filebeat/
├── scripts/
│   └── verify.sh
└── docs/
    ├── STRUCTURE.md
    ├── PORTS_AND_SG.md
    └── CHECKLIST.md
```

- `terraform.tfvars.example` — пример переменных, копируйте в `terraform.tfvars`.
- `inventory.ini.example` — пример инвентаря с bastion ProxyJump.
