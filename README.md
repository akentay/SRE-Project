# MedBook — SRE Observability Stack

## Quick Start

```bash
# 1. Place this folder next to MedBook-Mongo/ source directory
# 2. Run:
docker compose up --build -d

# 3. Access services:
#   App:         http://localhost:3000
#   Prometheus:  http://localhost:9090
#   Grafana:     http://localhost:3001  (admin / medbook123)
#   Alertmanager:http://localhost:9093
```

## Structure
```
MedBook-SRE/
├── Dockerfile.backend              # Node.js backend container
├── docker-compose.yml              # Full 8-service stack
└── monitoring/
    ├── prometheus.yml              # Scrape configs
    ├── alert_rules.yml             # 4 SLO alert rules
    ├── alertmanager.yml            # Alert routing
    ├── blackbox.yml                # HTTP probe config
    └── grafana/
        └── provisioning/
            └── datasources/
                └── prometheus.yml  # Auto-provisioned datasource
```

## Triggering the FIRING Alert (Demo)
```bash
docker stop medbook_backend
# Wait 2 minutes → see FIRING in http://localhost:9090/alerts
docker start medbook_backend   # restore
```
