
# **05 – Service Certificates**

## **Summary**
Service certificates provide TLS encryption and identity verification for all Elastic Stack components.  
This note explains **what service certificates are**, **why they are required**, and **how to create them** using the Intermediate CA and SAN templates.  
Each service (Elasticsearch, Kibana, Fleet Server, Logstash) receives its own certificate and private key.

---

# **1. What Are Service Certificates?**

Service certificates are X.509 certificates issued to individual Elastic components.  
They provide:

- **authentication** — the service proves its identity  
- **encryption** — TLS protects data in transit  
- **trust** — the certificate chains back to the Intermediate CA and Root CA  

Each service gets:

- a private key  
- a CSR  
- a signed certificate  
- a SAN file defining hostnames/IPs  
- a CA chain  

---

# **2. Why Do We Need Service Certificates?**

Elastic Stack requires TLS for:

- node‑to‑node communication  
- Kibana ↔ Elasticsearch  
- Fleet Server ↔ Elasticsearch  
- Logstash ↔ Elasticsearch  
- Elastic Agents ↔ Fleet Server  

Without service certificates:

- nodes cannot join the cluster  
- Kibana cannot connect  
- Fleet Server cannot enroll agents  
- Logstash pipelines will fail  
- TLS connections will be rejected  

Service certificates are mandatory for a secure Elastic deployment.

---

# **3. When Do We Create Service Certificates?**

Service certificates are created **after**:

- the Root CA  
- the Intermediate CA  
- the CA chain  

They are created **before**:

- configuring Elasticsearch  
- configuring Kibana  
- configuring Fleet Server  
- configuring Logstash  

---

# **4. Directory Structure (VM)**

Service certificates are stored under:

```
/opt/pki/services/
```

Each service has its own directory:

```
/opt/pki/services/
    elasticsearch/
    kibana/
    fleet_server/
    logstash/
```

Each directory contains:

```
private/
csr/
certs/
```

---

# **5. Template References**

SAN templates are stored under:

```
docs/10_pki/templates/
```

Templates include:

- `es-san.cnf`  
- `kibana-san.cnf`  
- `fleet-san.cnf`  
- `logstash-san.cnf`  

Copy the appropriate template into each service directory.

---

# **6. Creating Service Certificates**

The process is identical for each service:

1. Generate private key  
2. Generate CSR  
3. Sign certificate using Intermediate CA  
4. Verify certificate  
5. Verify chain  

Below is the generic workflow.

---

## **Step 1 — Generate the private key**

```
openssl genrsa -out private/<service>.key 4096
```

---

## **Step 2 — Generate the CSR**

```
openssl req -new \
  -key private/<service>.key \
  -out csr/<service>.csr \
  "/C=CA/ST=Ontario/L=Toronto/O=SOC Lab/OU=Elasticsearch/CN=elasticsearch"
```

---

## **Step 3 — Sign the certificate using the Intermediate CA**

```
openssl x509 -req \
  -in csr/<service>.csr \
  -CA /opt/pki/intermediate/certs/int-ca.crt \
  -CAkey /opt/pki/intermediate/private/int-ca.key \
  -CAcreateserial \
  -out certs/<service>.crt \
  -days 825 \
  -sha256 \
  -extfile <service>-san.cnf
  -extensions san
```

This applies SANs during signing.
> Note: -extensions san tells OpenSSL to use the [ san ] section in elasticsearch.cnf

---

## **Step 4 — Verify the certificate**

```
openssl x509 -in certs/<service>.crt -text -noout
```

Check:

- SANs  
- key usage  
- issuer  
- validity  

---

## **Step 5 — Verify the certificate chain**

```
openssl verify \
  -CAfile /opt/pki/intermediate/certs/ca-chain.crt \
  certs/<service>.crt
```

Elastic Stack requires a valid chain.

---

# **7. Service‑Specific Notes**

### **Elasticsearch**
Requires:

- node certificate  
- transport layer TLS  
- HTTP layer TLS  

SANs must include:

- hostname  
- IP address  
- localhost  

### **Kibana**
Requires:

- certificate for HTTPS  
- trust of Elasticsearch CA chain  

### **Fleet Server**
Requires:

- certificate for HTTPS  
- certificate for agent enrollment  
- SANs must include Fleet hostname  

### **Logstash**
Requires:

- certificate for Beats input  
- certificate for Elasticsearch output  

---

# **8. What We Do NOT Do With Service Certificates**

To keep the workflow clean:

- no SANs inside CSRs  
- no encrypted private keys  
- no `.ext` files  
- no wildcard certificates  
- no shared certificates between services  
- no direct signing by the Root CA  

Each service gets its own certificate.

---

# **9. Learning Notes & Study Material**

- Service certificates provide TLS and identity for each Elastic component.  
- All service certificates are signed by the Intermediate CA, not the Root CA.  
- SANs are applied during signing using the SAN templates.  
- Each service has its own directory under `/opt/pki/services/`.  
- The workflow is identical for all services: key → CSR → SAN → signed certificate → verification.  
- The CA chain (`Intermediate → Root`) must be included for Elastic to trust the certificate.  
- Service certificates must be created before configuring any Elastic component.  
- Keeping each service certificate isolated prevents configuration drift and improves clarity.  
- The SAN templates ensure consistency and prevent mistakes.  
- This step completes the PKI materials required for Elastic Stack TLS.

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

