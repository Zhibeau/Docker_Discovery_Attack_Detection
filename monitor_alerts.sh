#!/bin/bash

# Fonction pour afficher les logs Docker
monitor_docker_logs() {
    echo "=== Monitoring Docker API Access Logs ==="
    docker-compose logs -f vulnerable-docker | grep -i "api\|unauthorized\|access"
}

# Fonction pour afficher les alertes Elasticsearch
monitor_elastic_alerts() {
    echo "=== Monitoring Elasticsearch Alerts ==="
    curl -s http://localhost:9200/docker-*/_search -H 'Content-Type: application/json' -d '{
        "query": {
            "bool": {
                "should": [
                    {"term": {"docker.api.method": "GET"}},
                    {"term": {"event.type": "alert"}}
                ]
            }
        },
        "sort": [{"@timestamp": "desc"}],
        "size": 10
    }' | jq '.'
}

# Fonction pour afficher les alertes SNORT
monitor_snort_alerts() {
    echo "=== Monitoring SNORT Alerts ==="
    docker-compose logs -f | grep "SNORT" | grep "Alert"
}

# Boucle principale
while true; do
    clear
    echo "========================================="
    echo "        Security Monitoring Dashboard     "
    echo "========================================="
    
    monitor_docker_logs
    echo
    monitor_elastic_alerts
    echo
    monitor_snort_alerts
    
    sleep 5
done
