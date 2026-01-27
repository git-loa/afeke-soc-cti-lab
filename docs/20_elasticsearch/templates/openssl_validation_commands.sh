#!/bin/bash

# ==========================================
# Elasticsearch OpenSSL Validation (Template)
# ==========================================

echo "=== 1. Verify certificate against CA chain ==="
openssl verify \
  -CAfile /etc/elasticsearch/certs/ca-chain.crt \
  /etc/elasticsearch/certs/elasticsearch.crt

echo
echo "=== 2. Inspect certificate details ==="
openssl x509 -in /etc/elasticsearch/certs/elasticsearch.crt -text -noout

echo
echo "=== 3. Validate transport TLS (port 9300) ==="
openssl s_client -connect localhost:9300 \
  -CAfile /etc/elasticsearch/certs/ca-chain.crt
