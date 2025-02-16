#!/bin/bash

# Wait for Elasticsearch to be ready
until curl -s http://elasticsearch:9200 > /dev/null; do
    echo 'Waiting for Elasticsearch...'
    sleep 1
done

# Create the pipeline
curl -X PUT "http://elasticsearch:9200/_ingest/pipeline/docker-logs" -H 'Content-Type: application/json' -d @/elastic/docker-pipeline.json

# Create index template for docker logs
curl -X PUT "http://elasticsearch:9200/_template/docker-logs" -H 'Content-Type: application/json' -d '{
  "index_patterns": ["docker-logs-*"],
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {
      "@timestamp": { "type": "date" },
      "message": { "type": "text" },
      "docker.container.name": { "type": "keyword" },
      "docker.container.id": { "type": "keyword" },
      "level": { "type": "keyword" }
    }
  }
}'
