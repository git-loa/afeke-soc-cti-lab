#!/bin/bash

# ==========================================
# Elasticsearch HTTPS Validation (Template)
# ==========================================

echo "=== 1. HTTPS (insecure mode) ==="
curl -k -u elastic https://localhost:9200

echo
echo "=== 2. HTTPS with CA validation ==="
curl --cacert /etc/elasticsearch/certs/ca-chain.crt \
     -u elastic \
     https://localhost:9200

echo
echo "=== 3. HTTP should fail (plaintext disabled) ==="
curl http://localhost:9200
