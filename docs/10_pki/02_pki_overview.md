
# **02 – PKI Overview**

## **Summary**
Public Key Infrastructure (PKI) provides the trust model required for secure communication in the SOC/CTI lab.  
This note explains **what PKI is**, **why it is needed**, **how it is structured**, and **how this lab implements an industry‑standard PKI workflow**.  
This overview prepares you for building the Root CA, Intermediate CA, and service certificates.

---

# **1. What is PKI?**

PKI (Public Key Infrastructure) is a system for:

- creating  
- managing  
- distributing  
- validating  
- and revoking  

digital certificates.

A PKI provides:

- authentication  
- confidentiality  
- integrity  
- non‑repudiation  

PKI is the foundation of TLS, HTTPS, secure APIs, and encrypted communication across distributed systems.

---

# **2. Why do we need PKI in this lab?**

Elastic Stack requires **TLS encryption** for secure communication between:

- Elasticsearch nodes  
- Kibana ↔ Elasticsearch  
- Fleet Server ↔ Elasticsearch  
- Logstash ↔ Elasticsearch  
- Elastic Agents ↔ Fleet Server  

TLS requires certificates.  
Certificates require PKI.

Without PKI:

- nodes cannot trust each other  
- agents cannot enroll  
- Fleet Server cannot authenticate  
- Elasticsearch will refuse secure connections  

PKI is mandatory for a production‑grade Elastic deployment.

---

# **3. Industry‑Standard PKI Workflow**

This lab follows the same PKI structure used in real organizations.

### **3.1 PKI Hierarchy**

```
Root CA (offline, trust anchor)
        ↓ signs
Intermediate CA (online, operational CA)
        ↓ signs
Service Certificates (Elasticsearch, Kibana, Fleet, Logstash)
```

### **3.2 Why this structure is industry‑standard**

- The Root CA stays offline → maximum security  
- The Intermediate CA issues all certificates → operational flexibility  
- Service certificates never come directly from the Root CA  
- SANs are applied during signing → CA controls certificate extensions  
- The CA, not the requester, defines certificate capabilities  

This is the same structure used in:

- enterprise PKI  
- cloud infrastructure  
- internal TLS deployments  
- identity systems  
- secure microservices  

---

# **4. PKI Workflow Used in This Lab**

This lab uses a **clean, minimal, reproducible** PKI workflow:

### **Step 1 — Build the Root CA**
- Create Root CA key  
- Create Root CA certificate  
- Keep it offline  

### **Step 2 — Build the Intermediate CA**
- Create Intermediate CA key  
- Create Intermediate CA CSR  
- Sign it using the Root CA  
- Use it for all certificate issuance  

### **Step 3 — Create Service Certificates**
For each service:

- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

We:

- generate a private key  
- generate a CSR  
- apply a SAN file  
- sign the certificate using the Intermediate CA  

### **Step 4 — Build the CA Chain**
Concatenate:

```
Intermediate CA → Root CA
```

Elastic Stack requires this chain for trust.

---

# **5. Directory Structure (VM)**

All PKI files are stored under:

```
/opt/pki/
```

Structure:

```
/opt/pki/
    root/
        private/
        certs/
        db/
    intermediate/
        private/
        certs/
        db/
    services/
        elasticsearch/
        kibana/
        fleet_server/
        logstash/
```

This structure mirrors real CA layouts.

---

# **6. Template Files (Repo)**

Templates are stored under:

```
docs/10_pki/templates/
```

Templates include:

- `root-ca-openssl.cnf`  
- `int-ca-openssl.cnf`  
- `es-san.cnf`  
- `kibana-san.cnf`  
- `fleet-san.cnf`  
- `logstash-san.cnf`  

Each PKI step will reference the exact template to use.

---

# **7. What This Lab Does NOT Use**

To keep the workflow simple:

- no encrypted private keys  
- no `.ext` files  
- no SANs inside CSRs  
- no multiple PKI methods  
- no OCSP  
- no CRLs  
- no advanced OpenSSL engines  

We use **one clean, consistent PKI workflow**.

---

# **8. Learning Notes & Study Material**

- PKI provides the trust model required for TLS in Elastic Stack.  
- The Root CA must remain offline; the Intermediate CA handles all certificate issuance.  
- Service certificates must never be signed directly by the Root CA.  
- SANs are applied during certificate signing, not inside CSRs.  
- The CA controls certificate extensions, not the requester.  
- The PKI structure in this lab mirrors real enterprise PKI deployments.  
- The directory structure under `/opt/pki/` matches industry CA layouts.  
- The workflow is intentionally minimal to avoid confusion and ensure reproducibility.  
- Elastic Stack requires a valid CA chain for all TLS communication.  
- Templates ensure consistency and prevent configuration drift.

---

# **9. References**

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **Creating a Certificate Authority (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCreating_a_Certificate_Authority")  
  (Search: OpenSSL create certificate authority)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **NIST SP 800‑57 – Key Management Guidelines**  
  [https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)  
  (Search: NIST SP 800‑57 Part 1 Rev 5)

- **Elastic TLS Configuration Guide**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html)  
  (Search: elastic.co TLS configuration)

- **Elastic Security Settings Overview**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html)  
  (Search: Elastic security settings)
