
# **05 – Service Certificates**

## **Summary**
Service certificates provide TLS encryption and identity verification for all Elastic Stack components.  
Each service (Elasticsearch, Kibana, Fleet Server, Logstash) receives:

- a private key  
- a CSR generated from a service‑specific `.csr.cnf` file  
- a certificate signed by the Intermediate CA  
- a certificate chain  

All service certificates are issued by the **Intermediate CA**, not the Root CA.

---

# **1. What Service Certificates Are**
Service certificates are X.509 certificates issued to individual Elastic components.  
They provide:

- **authentication** — the service proves its identity  
- **encryption** — TLS protects data in transit  
- **trust** — the certificate chains to the Intermediate and Root CAs  

Each service has its own keypair and certificate.

---

# **2. Why They Are Required**
TLS is required for:

- Elasticsearch node‑to‑node transport  
- Kibana ↔ Elasticsearch  
- Fleet Server ↔ Elasticsearch  
- Elastic Agents ↔ Fleet Server  
- Logstash ↔ Elasticsearch  

Without valid certificates, components cannot connect securely.

---

# **3. When They Are Created**
Create service certificates **after**:

- Root CA  
- Intermediate CA  
- CA chain  

Create them **before** configuring:

- Elasticsearch  
- Kibana  
- Fleet Server    

---

# **4. Directory Structure**

Service certificates live under:

```
/opt/pki/intermediate/services/
```

Each service has:

```
<service>/
    private/
    csr/
    certs/
```

Secure the private key directory:

```
chmod 700 private/
```

---

# **5. SAN Template References**

SAN templates are stored under:

```
docs/10_pki/templates/
```

Examples:

- `es-san.cnf`
- `kibana-san.cnf`
- `fleet-san.cnf`
- `logstash-san.cnf`

Each service copies its template into its directory.

---

# **6. Creating Service Certificates**

The workflow is identical for all services:

1. Generate private key  
2. Generate CSR using `<service>.csr.cnf`  
3. Sign using the Intermediate CA (`openssl ca`)  
4. Verify certificate  
5. Verify chain  

---

## **Step 1 — Generate the private key**

```
openssl genrsa -out private/<service>.key 4096
chmod 600 private/<service>.key
```

---

## **Step 2 — Generate the CSR (using <service>.csr.cnf)**

Each service has a CSR config file.  
Example for Elasticsearch:

`elasticsearch.csr.cnf`:

```ini
[ req ]
prompt = no
distinguished_name = dn
req_extensions = san

[ dn ]
CN = elasticsearch.local
O  = SOC Lab


[ san ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = elasticsearch.local
DNS.2 = localhost
```

Generate the CSR:

```
openssl req -new -sha256 \
  -key private/elasticsearch.key \
  -config elasticsearch.csr.cnf \
  -out csr/elasticsearch.csr
```

This file defines the subject and SANs for the service.

---

## **Step 3 — Sign the certificate (Intermediate CA)**

From `/opt/pki/intermediate`:

```
openssl ca -config openssl.cnf \
  -extensions v3_service_cert \
  -days 825 \
  -notext \
  -md sha256 \
  -in services/<service>/csr/<service>.csr \
  -out services/<service>/certs/<service>.crt
```

This:

- updates the CA database  
- increments serial numbers  
- applies `[ v3_service_cert ]`  
- applies SANs  

---

## **Step 4 — Verify the certificate**

```
openssl x509 -in certs/<service>.crt -text -noout
```

---

## **Step 5 — Verify the certificate chain**

```
openssl verify \
  -CAfile /opt/pki/intermediate/certs/ca-chain.crt \
  certs/<service>.crt
```

---

# **7. Service‑Specific Notes**

### **Elasticsearch**
Requires:

- node certificate  
- transport TLS  
- HTTP TLS  

SANs must include hostname and localhost.

### **Kibana**
Requires:

- HTTPS certificate  
- trust of Elasticsearch CA chain  

### **Fleet Server**
Requires:

- HTTPS certificate  
- enrollment certificate  
- SANs must include Fleet hostname  

### **Logstash**
Requires:

- certificate for Beats input  
- certificate for Elasticsearch output  

---

# **8. What We Do NOT Do**

- no SANs inside CSRs  
- no encrypted private keys  
- no wildcard certificates  
- no shared certificates  
- no direct signing by the Root CA  

Each service receives its own certificate signed by the Intermediate CA.

---

# **9. Learning Notes**

- All service certificates are signed by the Intermediate CA.  
- SANs are defined in `<service>.csr.cnf`.  
- Workflow is identical across services.  
- The CA chain must be deployed with each service.  
- Certificates must exist before configuring Elastic components.  

---

# **10. References**

- OpenSSL Man Pages — req, x509, ca  
- OpenSSL PKI Tutorial (OpenSSL Wiki)  
- RFC 5280 — X.509 Certificate and CRL Profile  
- Elastic TLS Configuration Guide  
- Elastic Security Settings Overview  

---

# **10. References**

- **OpenSSL Man Pages – req, x509**  
  `https://www.openssl.org/docs/manmaster/man1/`  
  (Search: OpenSSL x509 command reference)

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **Elastic TLS Configuration Guide**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html)  
  (Search: elastic.co TLS configuration)

- **Elastic Security Settings Overview**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html)  
  (Search: Elastic security settings)

