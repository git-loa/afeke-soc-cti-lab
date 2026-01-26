
# **01 – OpenSSL Basics**

## **Summary**
OpenSSL is the cryptographic toolkit used to build and manage the PKI required for secure communication in the SOC/CTI lab.  
This note explains **what OpenSSL is**, **why it is used**, **when it is used**, and **how it fits into the PKI workflow**.  
Only the OpenSSL features needed for this lab are included here.  
Additional OpenSSL capabilities are documented separately in:

```
99_openssl_appendix.md
```

---

# **1. What is OpenSSL?**

OpenSSL is a command‑line cryptographic toolkit used for:

- generating private keys  
- creating certificate signing requests (CSRs)  
- signing certificates  
- applying SANs (Subject Alternative Names)  
- inspecting certificates  
- verifying certificate chains  
- managing CA database files  

These functions form the foundation of the PKI used by Elasticsearch, Kibana, Fleet Server, and Logstash.

---

# **2. Why do we use OpenSSL in this lab?**

Elastic Stack requires **TLS encryption** for secure communication.  
TLS requires certificates.  
Certificates require PKI.  
PKI requires OpenSSL.

OpenSSL is used because it is:

- widely supported  
- used in real SOC/CTI environments  
- compatible with offline Root/Intermediate CA setups  
- flexible and reliable  
- available on all Linux systems  

Without OpenSSL, we cannot build our own certificate authority.

---

# **3. What OpenSSL Features We Use in This Lab**

To keep the workflow simple and beginner‑friendly, we use only the PKI‑related features:

### **3.1 Key Generation**
Used to create private keys for:

- Root CA  
- Intermediate CA  
- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

### **3.2 CSR Creation**
Used to request certificates for:

- Intermediate CA  
- All Elastic services  

### **3.3 Certificate Signing**
Used by:

- Root CA → to sign the Intermediate CA  
- Intermediate CA → to sign service certificates  

### **3.4 SAN Application**
SANs (DNS/IP entries) are applied **during signing**, not inside the CSR.

### **3.5 Certificate Inspection**
Used to confirm:

- validity  
- SANs  
- key usage  
- issuer  
- expiration  

### **3.6 Chain Verification**
Used to ensure:

- service certificates chain correctly  
- Elastic Stack trusts the CA hierarchy  

These are the only OpenSSL features required for the PKI workflow.

---

# **4. When Do We Use OpenSSL?**

OpenSSL is used during **four stages** of the PKI workflow:

### **Stage 1 — Create the Root CA**
- Generate Root CA private key  
- Generate Root CA certificate  

### **Stage 2 — Create the Intermediate CA**
- Generate Intermediate CA private key  
- Generate Intermediate CA CSR  
- Sign Intermediate CA certificate using the Root CA  

### **Stage 3 — Create Service Certificates**
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

### **Stage 4 — Validate Certificates**
We:

- inspect certificate contents  
- verify certificate chains  
- confirm SANs  

---

# **5. Where Do We Use OpenSSL?**

All OpenSSL commands are executed **inside the VM**, not on your host machine.

All PKI files are stored under:

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

Each documentation file will specify:

- which directory to run commands in  
- which template file to copy  
- what to edit  
- what output to expect  

No assumptions.

---

# **6. Key OpenSSL Commands Used in This Lab**

### **Generate a private key**
```
openssl genrsa -out <name>.key 4096
```

### **Generate a CSR**
```
openssl req -new -key <name>.key -out <name>.csr -subj "/CN=example"
```

### **Sign a certificate (Intermediate CA signs service certs)**
```
openssl x509 -req \
  -in <name>.csr \
  -CA int-ca.crt \
  -CAkey int-ca.key \
  -CAcreateserial \
  -out <name>.crt \
  -days 825 \
  -sha256 \
  -extfile <san-file>
```

### **Inspect a certificate**
```
openssl x509 -in <name>.crt -text -noout
```

### **Verify a certificate chain**
```
openssl verify -CAfile ca-chain.crt <name>.crt
```

These commands form the core of the PKI workflow.

---

# **7. What We Do NOT Use (to avoid confusion)**

To keep the workflow simple:

- No `.ext` files  
- No SANs inside CSRs  
- No encrypted private keys  
- No advanced OpenSSL engines  
- No multiple PKI methods  

We use **one clean, consistent workflow** only.

---

# **8. Additional OpenSSL Features (Optional)**

OpenSSL can do much more, including:

- hashing  
- encryption/decryption  
- TLS testing  
- key conversions  
- random number generation  
- file encryption  
- format conversions  

These are documented separately in:

```
99_openssl_appendix.md
```

This keeps the main PKI workflow clean and focused.

---

# **9. Learning Notes & Study Material**

- OpenSSL is the core tool for building the PKI in this lab.  
- Only the essential PKI‑related features are used: key generation, CSR creation, certificate signing, SAN application, certificate inspection, and chain verification.  
- SANs must be applied during certificate signing, not inside the CSR.  
- The Root CA remains offline; the Intermediate CA performs all certificate issuance.  
- All PKI work is done inside the VM under `/opt/pki/` to keep the environment reproducible and isolated.  
- The workflow is intentionally minimal to avoid confusion and match industry‑standard CA structures.  
- Running OpenSSL commands from the correct directory is critical to avoid mixing CA files.  
- Certificate chains must always be verified before using them in Elastic Stack.  
- This lab uses a single, clean PKI workflow — no `.ext` files, no encrypted keys, no alternate methods.  
- Advanced OpenSSL features are useful but not required for this PKI build.

---

# **10. References**

- **OpenSSL Documentation (Official)**  
  [https://www.openssl.org/docs/](https://www.openssl.org/docs/)  
  (Search: OpenSSL official documentation)

- **OpenSSL Man Pages (Command Reference)**  
  `https://www.openssl.org/docs/manmaster/man1/` [(openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.openssl.org%2Fdocs%2Fmanmaster%2Fman1%2F")  
  (Search: OpenSSL command reference)

- **OpenSSL Cookbook (Feisty Duck)**  
  `https://www.feistyduck.com/library/openssl-cookbook/` [(feistyduck.com in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.feistyduck.com%2Flibrary%2Fopenssl-cookbook%2F")  
  (Search: OpenSSL Cookbook)

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **OpenSSL Certificate Authority Guide (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCreating_a_Certificate_Authority")  
  (Search: OpenSSL create certificate authority)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **NIST SP 800‑57 – Key Management Guidelines**  
  [https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)  
  (Search: NIST SP 800‑57 Part 1 Rev 5)
