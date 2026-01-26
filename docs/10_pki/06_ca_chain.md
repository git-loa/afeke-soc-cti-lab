
# **06 – CA Chain**

## **Summary**
The CA chain links the Intermediate CA certificate to the Root CA certificate.  
Elastic Stack requires this chain to validate service certificates.  
This note explains **what the CA chain is**, **why it is required**, and **how to build and verify it**.

---

# **1. What is the CA Chain?**

The CA chain is a file that contains:

1. the Intermediate CA certificate  
2. the Root CA certificate  

in that exact order.

It represents the trust path from a service certificate → Intermediate CA → Root CA.

---

# **2. Why Do We Need a CA Chain?**

Elastic Stack requires the CA chain for:

- validating service certificates  
- establishing trust between components  
- verifying that certificates were issued by a trusted CA  
- enabling TLS for Elasticsearch, Kibana, Fleet Server, and Logstash  

Without the CA chain:

- TLS connections fail  
- nodes cannot join the cluster  
- Kibana cannot connect  
- Fleet Server cannot enroll agents  
- Logstash pipelines break  

The CA chain is mandatory for secure Elastic deployments.

---

# **3. When Do We Create the CA Chain?**

The CA chain is created **after**:

- the Root CA certificate  
- the Intermediate CA certificate  

It is created **before**:

- generating service certificates  
- configuring Elastic Stack  

---

# **4. Directory Structure (VM)**

The CA chain is stored under:

```
/opt/pki/intermediate/certs/
```

This keeps it alongside the Intermediate CA certificate.

---

# **5. Building the CA Chain**

Navigate to:

```
/opt/pki/intermediate/certs/
```

Run:

```
cat int-ca.crt /opt/pki/root/certs/root-ca.crt > ca-chain.crt
```

Order matters:

1. Intermediate CA  
2. Root CA  

Elastic Stack will reject the chain if the order is reversed.

---

# **6. Verifying the CA Chain**

### **Step 1 — Inspect the chain**

```
openssl x509 -in ca-chain.crt -text -noout
```

You should see:

- Intermediate CA certificate first  
- Root CA certificate second  

### **Step 2 — Verify the Intermediate CA against the Root CA**

```
openssl verify \
  -CAfile /opt/pki/root/certs/root-ca.crt \
  /opt/pki/intermediate/certs/int-ca.crt
```

Expected output:

```
int-ca.crt: OK
```

### **Step 3 — Verify a service certificate against the chain**

```
openssl verify \
  -CAfile ca-chain.crt \
  /opt/pki/services/elasticsearch/certs/elasticsearch.crt
```

Expected output:

```
elasticsearch.crt: OK
```

---

# **7. What We Do NOT Do With the CA Chain**

To maintain a clean PKI:

- we do **not** include service certificates in the chain  
- we do **not** reverse the order (Root → Intermediate is invalid)  
- we do **not** modify the chain after creation  
- we do **not** store the chain in multiple locations  
- we do **not** mix CA chains between environments  

The CA chain must remain consistent and predictable.

---

# **8. Learning Notes & Study Material**

- The CA chain links the Intermediate CA to the Root CA.  
- Elastic Stack requires the CA chain for all TLS validation.  
- The order of certificates in the chain matters: Intermediate → Root.  
- The chain must be created before configuring any Elastic component.  
- Verification ensures that the trust hierarchy is intact.  
- The CA chain is stored under `/opt/pki/intermediate/certs/`.  
- Service certificates are validated against the CA chain, not the Root CA alone.  
- A broken or misordered chain will cause TLS failures across Elastic Stack.  
- The CA chain is static — it does not change after creation.  
- This step completes the PKI foundation required for secure Elastic communication.

---

# **9. References**

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **Creating a Certificate Authority (OpenSSL Wiki)**  
  `https://wiki.openssl.org/index.php/Creating_a_Certificate_Authority` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCreating_a_Certificate_Authority")  
  (Search: OpenSSL create certificate authority)

- **OpenSSL Man Pages – x509, verify**  
  `https://www.openssl.org/docs/manmaster/man1/` [(openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.openssl.org%2Fdocs%2Fmanmaster%2Fman1%2F")  
  (Search: OpenSSL verify command reference)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)

- **Elastic TLS Configuration Guide**  
  [https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html)  
  (Search: elastic.co TLS configuration)

