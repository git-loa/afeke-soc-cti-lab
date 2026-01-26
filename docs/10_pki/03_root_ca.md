
# **03 – Root CA**

## **Summary**
The Root Certificate Authority (Root CA) is the trust anchor of the entire PKI.  
It signs the Intermediate CA certificate and must remain offline for security.  
This note explains **what the Root CA is**, **why it is needed**, and **how to create it** using OpenSSL and the provided template.

---

# **1. What is the Root CA?**

The Root CA is the highest‑level certificate authority in the PKI hierarchy.  
It is responsible for:

- creating the Root CA private key  
- creating the Root CA certificate  
- signing the Intermediate CA certificate  
- establishing the trust anchor for all service certificates  

The Root CA **never** signs service certificates directly.

---

# **2. Why do we need a Root CA?**

The Root CA provides:

- the ultimate source of trust  
- the top of the certificate chain  
- the authority that validates the Intermediate CA  
- the foundation for all TLS communication in Elastic Stack  

If the Root CA is compromised, the entire PKI is compromised.

This is why the Root CA:

- must remain offline  
- must be used only for signing the Intermediate CA  
- must be stored securely  

---

# **3. When do we create the Root CA?**

The Root CA is created **first**, before:

- the Intermediate CA  
- any service certificates  
- any SAN files  
- any CA chains  

It is the starting point of the PKI workflow.

---

# **4. Directory Structure (VM)**

Create the Root CA directory under:

```
/opt/pki/root/
```

Recommended structure:

```
/opt/pki/root/
    private/
    certs/
    db/
```

Initialize the CA database:

```
touch /opt/pki/root/db/index.txt
echo 1000 > /opt/pki/root/db/serial
```

This matches industry CA layouts.

---

# **5. Template Reference**

Use the Root CA OpenSSL configuration template:

```
docs/10_pki/templates/root-ca-openssl.cnf
```

Copy it into the VM:

```
/opt/pki/root/root-ca-openssl.cnf
```

This template defines:

- key usage  
- basic constraints  
- certificate policies  
- CA extensions  
- validity period  

---

# **6. Creating the Root CA**

### **Step 1 — Generate the Root CA private key**

```
openssl genrsa -out private/root-ca.key 4096
```

### **Step 2 — Generate the Root CA certificate**

```
openssl req -x509 \
  -new \
  -nodes \
  -key private/root-ca.key \
  -sha256 \
  -days 3650 \
  -config root-ca-openssl.cnf \
  -out certs/root-ca.crt
```

This creates a self‑signed Root CA certificate.

### **Step 3 — Verify the Root CA certificate**

```
openssl x509 -in certs/root-ca.crt -text -noout
```

Confirm:

- CA:TRUE  
- keyCertSign  
- basicConstraints  
- validity period  

---

# **7. What We Do NOT Do With the Root CA**

To maintain security:

- we do **not** use the Root CA to sign service certificates  
- we do **not** keep the Root CA online  
- we do **not** reuse the Root CA key  
- we do **not** store the Root CA in the same directory as the Intermediate CA  

The Root CA is used **once**, then stored securely.

---

# **8. Learning Notes & Study Material**

- The Root CA is the trust anchor of the entire PKI.  
- It must remain offline and is only used to sign the Intermediate CA.  
- The Root CA certificate is self‑signed; all other certificates chain back to it.  
- The Root CA key must be protected — compromise invalidates the entire PKI.  
- The directory structure under `/opt/pki/root/` mirrors real enterprise CA layouts.  
- The Root CA template defines CA‑specific extensions such as `basicConstraints = CA:TRUE`.  
- The Root CA is created before any other PKI components.  
- The Root CA certificate is long‑lived; service certificates are short‑lived.  
- Verification of the Root CA certificate ensures correct extensions and validity.  
- This step sets the foundation for the Intermediate CA and all service certificates.

---

# **9. References**

- **Creating a Certificate Authority (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCreating_a_Certificate_Authority")  
  (Search: OpenSSL create certificate authority)

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **OpenSSL Man Pages – req, x509**  
  `https://www.openssl.org/docs/manmaster/man1/` [(openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.openssl.org%2Fdocs%2Fmanmaster%2Fman1%2F")  
  (Search: OpenSSL x509 command reference)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **NIST SP 800‑57 – Key Management Guidelines**  
  [https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final](https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final)  
  (Search: NIST SP 800‑57 Part 1 Rev 5)

