
# **04 – Intermediate CA**

## **Summary**
The Intermediate Certificate Authority (Intermediate CA) is the operational CA responsible for issuing all service certificates in the lab.  
This note explains **what the Intermediate CA is**, **why it is required**, and **how to create it** using OpenSSL and the provided template.  
The Intermediate CA is signed by the Root CA and becomes the CA used for all certificate issuance.

---

# **1. What is the Intermediate CA?**

The Intermediate CA is the certificate authority that:

- issues all service certificates  
- signs CSRs for Elasticsearch, Kibana, Fleet Server, and Logstash  
- enforces certificate extensions and SANs  
- protects the Root CA by acting as a buffer  

It is the CA used for all day‑to‑day certificate operations.

---

# **2. Why do we need an Intermediate CA?**

Using an Intermediate CA provides:

- **security** — the Root CA stays offline  
- **flexibility** — service certificates can be issued without exposing the Root CA  
- **revocation control** — the Intermediate CA can be replaced without rebuilding the Root CA  
- **industry alignment** — all modern PKI deployments use a Root → Intermediate structure  

If the Intermediate CA is compromised, the Root CA remains safe.

---

# **3. When do we create the Intermediate CA?**

The Intermediate CA is created **after** the Root CA and **before** any service certificates.

Workflow:

1. Create Intermediate CA private key  
2. Create Intermediate CA CSR  
3. Sign the CSR using the Root CA  
4. Verify the Intermediate CA certificate  
5. Build the CA chain  

---

# **4. Prepare the intermediate CA directory (VM)**

Create the Intermediate CA directory under:

```
/opt/pki/intermediate/
```

Recommended structure:

```
/opt/pki/intermediate/
    private/
    certs/
    db/
```

Create and initialize
``bash
sudo mkdir -p /opt/pki/intermediate/{certs,crl,csr,db,private}
sudo chmod 700 /opt/pki/intermediate/private
sudo touch /opt/pki/intermediate/db/index.txt
echo 1000 | sudo tee /opt/pki/intermediate/db/serial
echo 1000 | sudo tee /opt/pki/intermediate/db/crlnumber
```
---

# **5. Template Reference**

Use the Intermediate CA OpenSSL configuration template:

```
docs/10_pki/templates/int-ca-openssl.cnf
```

Copy it into the VM:

```
/opt/pki/intermediate/int-ca-openssl.cnf
```

This template defines:

- CA:TRUE  
- path length constraints  
- key usage  
- certificate policies  
- Intermediate CA extensions  

---

# **6. Creating the Intermediate CA**

### **Step 1 — Generate the Intermediate CA private key**

```
openssl genrsa -aes256 -out private/int-ca.key 4096
```

### **Step 2 — Generate the Intermediate CA CSR**

```
sudo openssl req -config int-ca-openssl.cnf \
  -new -sha256 \
  -key private/int-ca.key \
  -out csr/int-ca.csr
```

### **Step 3 — Sign the Intermediate CA certificate using the Root CA**

Run this from the **Root CA directory**: `/opt/pki/root`
```
cd /opt/pki/root
```

and run the following:

```
sudo openssl ca -config root-ca-openssl.cnf \
  -extensions v3_intermediate_ca \
  -days 1825 \
  -notext \
  -md sha256 \
  -in ../intermediate/csr/int-ca.csr \
  -out certs/int-ca.crt
```

This creates a Root‑signed Intermediate CA certificate.

### **Step 4 — Verify the Intermediate CA certificate**

```
openssl x509 -in certs/int-ca.crt -text -noout
```

Confirm:

- CA:TRUE  
- pathlen:0  
- keyCertSign  
- correct issuer (Root CA)  

### **Step 5 — Build the CA chain**

```
cat certs/int-ca.crt /opt/pki/root/certs/root-ca.crt > certs/ca-chain.crt
```

### After generating the chain, verify it
```code
sudo openssl x509 -in certs/ca-chain.crt -text -noout
```
You should see:

- Intermediate CA certificate

- Root CA certificate

in that order.

Elastic Stack requires this chain for trust.

---

# **7. What We Do NOT Do With the Intermediate CA**

To maintain a clean PKI:

- we do **not** use the Intermediate CA to sign the Root CA  
- we do **not** mix Root CA and Intermediate CA files  
- we do **not** store Intermediate CA keys in the Root CA directory  
- we do **not** issue certificates without SANs  
- we do **not** modify the Intermediate CA certificate after signing  

The Intermediate CA is the only CA used for service certificates.

---

# **8. Learning Notes & Study Material**

- The Intermediate CA is the operational CA used for all certificate issuance.  
- It is signed by the Root CA and inherits trust from it.  
- The Root CA stays offline; the Intermediate CA stays online.  
- The Intermediate CA template defines CA‑specific extensions such as `pathlen:0`.  
- The Intermediate CA must be created before any service certificates.  
- The CA chain (`Intermediate → Root`) is required by Elastic Stack for TLS validation.  
- The Intermediate CA directory structure mirrors real enterprise CA layouts.  
- Signing the Intermediate CA CSR with the Root CA establishes the trust hierarchy.  
- Verification ensures correct extensions and issuer relationships.  
- This step completes the CA hierarchy and prepares for service certificate creation.

---

# **9. References**

- **Creating a Certificate Authority (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority`  
  (Search: OpenSSL create certificate authority)

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **OpenSSL Man Pages – ca, req, x509**  
  `https://www.openssl.org/docs/manmaster/man1/`  
  (Search: OpenSSL ca command reference)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **NIST SP 800‑57 – Key Management Guidelines**  
  [https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)  
  (Search: NIST SP 800‑57 Part 1 Rev 5)
