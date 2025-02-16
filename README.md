# Docker API Security Monitoring

## Project Overview
This project implements a comprehensive security monitoring solution for Docker API access, focusing on detecting and logging unauthorized access attempts and suspicious activities.

## Architecture Components

### 1. Vulnerable Docker Environment
- Exposed Docker API on port 2375 (intentionally unsecured for testing)
- Container running with Docker socket mounted
- Network isolation using custom Docker network

### 2. Log Collection
- **Filebeat**: Collects and forwards Docker API logs
- Configured for JSON log parsing
- Monitors container logs and Docker daemon events

### 3. Analysis Stack
- **Elasticsearch (7.17.0)**: Log storage and analysis
- **Kibana (7.17.0)**: Log visualization and search interface
- Custom index patterns for Docker API monitoring

### 4. Network Security
- **Snort IDS**: Network-based intrusion detection
- Custom rules for Docker API access monitoring
- Alert generation for suspicious activities

## Directory Structure
- `docker-compose.yml`: Main deployment configuration
- `filebeat.yml`: Filebeat configuration for log collection
- `Dockerfile.vulnerable`: Vulnerable Docker container configuration
- `snort_rules/`: 
  - `docker_api_access.rules`: Snort rules for API monitoring
  - `snort.conf`: Snort configuration
  - `unicode.map`: Character mapping for Snort

## Setup Instructions
1. Start the environment:
   ```bash
   docker-compose up -d
   ```

2. Configure Kibana:
   - Access Kibana at http://localhost:5601
   - Create index pattern `filebeat-*`
   - Import saved searches and dashboards

## Monitoring
### Kibana Search Queries
1. All Docker API calls:
   ```
   container.name: "devoir-vulnerable-docker*" AND message: "*API*"
   ```

2. Specific API endpoints:
   ```
   container.name: "devoir-vulnerable-docker*" AND message: "*/containers/json*" OR message: "*/info*" OR message: "*/version*"
   ```

3. Unauthorized access:
   ```
   container.name: "devoir-vulnerable-docker*" AND message: "*unauthorized*" OR message: "*forbidden*"
   ```

## Security Notes
- The Docker API is intentionally exposed without TLS for testing
- This setup is for educational purposes only
- Do not use this configuration in production environments

## Prerequisites
- Docker and Docker Compose
- Elasticsearch 7.17.0
- Kibana 7.17.0
- Filebeat 7.17.0
- Snort IDS
