
# **03 — Elasticsearch TLS Configuration (elasticsearch.yml)**

This step enables HTTPS for Elasticsearch by configuring TLS settings in `elasticsearch.yml`.  
Elasticsearch 8.x requires security features (TLS + authentication) to be enabled before the service can start.

---

## **1. Edit elasticsearch.yml**

Open the configuration file:

```
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add or update the following sections.

---

## **2. Enable Security Features**

```
xpack.security.enabled: true
```

Notes:

- Enables authentication, authorization, and TLS  
- Required for all Elastic Stack 8.x deployments  

---

## **3. Enable HTTPS for the HTTP Layer**

```
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.key: certs/elasticsearch.key
xpack.security.http.ssl.certificate: certs/elasticsearch.crt
xpack.security.http.ssl.certificate_authorities: [ "certs/ca-chain.crt" ]
```

Notes:

- Enables HTTPS on port 9200  
- Certificate paths are relative to `/etc/elasticsearch/`  
- The CA chain must include both Intermediate and Root CA  

---

## **4. Enable TLS for the Transport Layer**

```
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.key: certs/elasticsearch.key
xpack.security.transport.ssl.certificate: certs/elasticsearch.crt
xpack.security.transport.ssl.certificate_authorities: [ "certs/ca-chain.crt" ]
```

Notes:

- Required for node‑to‑node communication  
- `verification_mode: certificate` enforces mutual trust  
- Even in a single‑node lab, this must be enabled  

---

## **5. Optional: Set Node and Cluster Information**

Example:

```
cluster.name: soc-lab
node.name: es01
network.host: 0.0.0.0
```

Notes:

- `network.host` controls binding behavior  
- For a single‑node lab, `0.0.0.0` is acceptable  
- For production, restrict to specific interfaces  

---

## **6. Reload and Start Elasticsearch**

```
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

Check status:

```
sudo systemctl status elasticsearch
```

Notes:

- If TLS paths or permissions are incorrect, Elasticsearch will fail to start  
- Logs are located under `/var/log/elasticsearch/`  

---

## **7. Validate HTTPS Connectivity**

### **Using insecure mode (quick test)**

```
curl -k -u elastic https://localhost:9200
```

### **Using full certificate validation**

```
curl --cacert /etc/elasticsearch/certs/ca-chain.crt \
     -u elastic \
     https://localhost:9200
```

Expected output:

- JSON response with cluster name  
- No TLS errors  
- Authentication prompt for the `elastic` user  

---

## **8. Learning Notes**

- Elasticsearch will not start without valid TLS configuration  
- Both HTTP and transport layers must be secured  
- Certificate paths must be relative to `/etc/elasticsearch/`  
- Permissions on the private key must be strict (`600`)  
- This configuration prepares Elasticsearch for Kibana, Fleet, and Logstash  

---

# **10. References**

- **Elastic TLS Configuration Guide**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html`  
  (Search: elastic.co configuring TLS)

- **Elasticsearch Security Settings Overview**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html`  
  (Search: elastic.co security settings)

- **Elasticsearch HTTP and Transport Security**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup-https.html`  
  (Search: elastic.co enable HTTPS)

- **Elasticsearch Configuration File Reference**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html`  
  (Search: elastic.co elasticsearch.yml settings)
