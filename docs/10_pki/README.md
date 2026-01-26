# **Public Key Infrastructure (PKI) – Documentation Overview**

## **Purpose**
This folder contains all documentation, templates, and notes required to build a complete, reproducible Public Key Infrastructure (PKI) for the SOC/CTI lab.  
The PKI created here provides the certificates and trust model required for secure TLS communication across Elastic Stack components.

The structure, workflow, and directory layout follow **industry‑standard PKI practices**.

---

# **Folder Structure**

```
10_pki/
│
├── 01_openssl_basics.md
├── 02_pki_overview.md
├── 03_root_ca.md
├── 04_intermediate_ca.md
├── 05_service_certificates.md
├── 06_ca_chain.md
│
├── 99_openssl_appendix.md
│
└── templates/
      ├── root-ca-openssl.cnf
      ├── int-ca-openssl.cnf
      ├── es-san.cnf
      ├── kibana-san.cnf
      ├── fleet-san.cnf
      ├── logstash-san.cnf
      └── README.md
```

---

# **What This PKI Covers**

### **1. Root CA**
- Trust anchor of the PKI  
- Offline, long‑lived  
- Signs the Intermediate CA only  

### **2. Intermediate CA**
- Operational CA  
- Issues all service certificates  
- Signed by the Root CA  

### **3. Service Certificates**
Certificates for:

- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

Each service receives:

- private key  
- CSR  
- signed certificate  
- SAN file  
- CA chain  

### **4. CA Chain**
- Intermediate CA → Root CA  
- Required by Elastic Stack for TLS validation  

### **5. OpenSSL Basics + Appendix**
- Core commands used in the lab  
- Additional OpenSSL features (optional)  
- Troubleshooting and TLS testing tools  

---

# **Workflow Summary**

The PKI workflow is intentionally simple and mirrors real enterprise PKI:

1. **Create Root CA**  
   - Generate key  
   - Generate self‑signed certificate  

2. **Create Intermediate CA**  
   - Generate key  
   - Generate CSR  
   - Sign with Root CA  
   - Build CA chain  

3. **Create Service Certificates**  
   - Generate key  
   - Generate CSR  
   - Apply SAN template  
   - Sign with Intermediate CA  
   - Verify certificate + chain  

4. **Use Certificates in Elastic Stack**  
   - Elasticsearch transport + HTTP TLS  
   - Kibana HTTPS  
   - Fleet Server HTTPS + enrollment  
   - Logstash Beats input + ES output  

---

# **Design Principles**

- **Beginner‑friendly**: no assumptions, no hidden steps  
- **Reproducible**: consistent directory structure and templates  
- **Industry‑aligned**: Root → Intermediate → Service hierarchy  
- **Minimal**: only the PKI features required for Elastic Stack  
- **Secure**: Root CA offline, Intermediate CA operational  
- **Clear separation**: templates, documentation, and PKI artifacts  

---

# **Where PKI Files Live (VM)**

All PKI artifacts are stored under:

```
/opt/pki/
```

Structure:

```
/opt/pki/
    root/
    intermediate/
    services/
        elasticsearch/
        kibana/
        fleet_server/
        logstash/
```

This mirrors real CA directory layouts.

---

# **Templates**

All OpenSSL configuration and SAN templates are stored under:

```
docs/10_pki/templates/
```

Templates ensure:

- consistent certificate extensions  
- correct SAN handling  
- predictable PKI behavior  
- reproducible builds  

---

# **Learning Notes**

- PKI is mandatory for secure Elastic Stack communication.  
- The Root CA is the trust anchor; the Intermediate CA handles all issuance.  
- SANs must be applied during certificate signing, not inside CSRs.  
- The CA chain is required for all TLS validation in Elastic Stack.  
- The workflow is intentionally minimal to avoid confusion and match real PKI deployments.  
- Templates prevent configuration drift and ensure correctness.  
- The directory structure mirrors enterprise CA layouts.  
- Understanding this PKI makes TLS troubleshooting significantly easier in real SOC/CTI work.  

---

# **References**

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **Creating a Certificate Authority (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCreating_a_Certificate_Authority")  
  (Search: OpenSSL create certificate authority)

- **OpenSSL Man Pages – req, x509, ca, verify**  
  `https://www.openssl.org/docs/manmaster/man1/` [(openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.openssl.org%2Fdocs%2Fmanmaster%2Fman1%2F")  
  (Search: OpenSSL command reference)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **NIST SP 800‑57 – Key Management Guidelines**  
  [https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)  
  (Search: NIST SP 800‑57 Part 1 Rev 5)

- **Elastic TLS Configuration Guide**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html)  
  (Search: elastic.co TLS configuration)

