# Docker API Security Monitoring System

## Project Overview
A comprehensive security monitoring environment for detecting unauthorized Docker API access and potential network scanning activities.

## Architecture Components

### Core Services
- **Elasticsearch (7.17.0)**: Log storage and analysis engine
- **Kibana (7.17.0)**: Visualization and search interface
- **Filebeat (7.17.0)**: Log collection and forwarding
- **Snort IDS**: Network intrusion detection

### Network Configuration
- Custom Docker network (`attack_net`)
- Vulnerable Docker container exposed on port 2375
- Attacker container for security testing

## Architecture Diagram
```
+-------------------------------------------------------------------------+
|                           Docker Network (attack_net)                   |
|                                                                         |
|  +----------------+        +-------------------+      +--------------+  |
|  |  Attacker      |  scan  |   Vulnerable      |      |              |  |
|  |  Container     |------->|   Docker          |      |   Snort IDS  |  |
|  |  [masscan]     |        |   API:2375        |      |   [Monitor]  |  |
|  +----------------+        +-------------------+      +--------------+  |
|          |                         |                         |          |
|          |                         |                         |          |
|          v                         v                         v          |
|  +----------------+        +-------------------+      +--------------+  |
|  |   Filebeat     |------->|   Elasticsearch   |<-----|   Kibana     |  |
|  |   [Collector]  |        |   [Storage]       |      |   [Display]  |  |
|  +----------------+        +-------------------+      +--------------+  |
|                                                                         |
|  Log Flow:                    Alert Flow:                               |
|  Attacker -> Docker API       Snort -> Filebeat                         |
|  Docker API -> Filebeat       Filebeat -> Elasticsearch                 |
|  Filebeat -> Elasticsearch    Elasticsearch -> Kibana                   |
|                                                                         |
+-------------------------------------------------------------------------+

Container Details:
┌─ Attacker
│  ├─ Tools: masscan, curl
│  └─ Purpose: Network scanning, API probing
│
├─ Vulnerable Docker
│  ├─ Exposed: Port 2375
│  └─ Features: Unencrypted API, Debug logging
│
├─ Snort IDS
│  ├─ Rules: Docker API monitoring
│  └─ Alerts: Port scans, API abuse
│
├─ Filebeat
│  ├─ Sources: Docker logs, Snort alerts
│  └─ Output: Elasticsearch
│
├─ Elasticsearch
│  ├─ Indices: filebeat-network-*
│  └─ Pipeline: Scan detection
│
└─ Kibana
   ├─ Dashboards: Network monitoring
   └─ Queries: Scan detection
```

## Monitoring Features

### Network Activity Monitoring
- Real-time port scan detection
- TCP connection tracking
- Docker API access logging
- Timestamp-based correlation of events

### Log Collection
- Filtered network-related logs
- Docker API access events
- Container activity monitoring
- Scan attempt detection

### Detection Capabilities
1. **Network-based Detection (Snort)**
   - Unauthorized container listing
   - Version enumeration attempts
   - System information gathering
   - Port scanning activities
   - Rapid successive requests
   - Multiple endpoint access

2. **Log-based Detection (Filebeat + Elasticsearch)**
   - Docker API access patterns
   - Network scan signatures
   - HTTP GET/POST requests to Docker API
   - Connection attempts to port 2375

## Kibana Search Queries

### Finding Scan Activities
```
event.type: "network_scan"
```

### Monitoring Port 2375
```
port: 2375
```

### Tracking Masscan Activities
```
message: "*masscan*" or message: "*Discovered open port*"
```

## Setup Instructions

1. **Build and Start Services**
   ```bash
   docker-compose up -d
   ```

2. **Access Monitoring Interface**
   - Kibana: http://localhost:5601
   - Elasticsearch: http://localhost:9200

3. **Test Attack Scenario**
   ```bash
   docker-compose exec attacker ./attack_scenario.sh
   ```

## Security Notes

### Logging Configuration
- Network activity logs stored in `filebeat-network-*` indices
- Custom pipeline for parsing scan-related data
- Timestamp correlation between attack execution and detection

### Best Practices
1. Monitor Kibana dashboards regularly
2. Review Snort alerts for unauthorized access
3. Check Elasticsearch indices for suspicious patterns
4. Correlate timestamps between attack attempts and detections

## File Structure
```
.
├── docker-compose.yml          # Service orchestration
├── Dockerfile.vulnerable       # Vulnerable container configuration
├── Dockerfile.attacker        # Attack simulation container
├── filebeat.yml              # Log collection configuration
├── snort_rules/              # Network detection rules
├── elastic/                  # Elasticsearch configuration
│   ├── docker-pipeline.json  # Log parsing pipeline
│   └── init-elasticsearch.sh # Index initialization
└── attack_scenario.sh        # Attack simulation script
```

## Recent Updates
- Added timestamp logging to attack scenarios
- Improved network activity filtering in Filebeat
- Enhanced log parsing pipeline for scan detection
- Added specific Kibana queries for monitoring

## Troubleshooting
1. Check Filebeat logs for collection status
2. Verify Elasticsearch indices are being created
3. Ensure Snort rules are properly loaded
4. Monitor Docker container logs for issues

## Future Improvements
1. Add TLS encryption for Docker API
2. Implement more granular access controls
3. Enhance alert correlation
4. Create custom Kibana dashboards
5. Add machine learning for anomaly detection

## Contributing
Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
