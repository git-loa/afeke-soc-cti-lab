
# **99 – OpenSSL Appendix**

## **Summary**
This appendix provides a compact reference of OpenSSL features beyond the PKI workflow used in this lab.  
It includes cryptographic utilities, TLS debugging tools, key conversions, file encryption, hashing, and other commonly used OpenSSL commands.  
These notes are optional but valuable for deeper understanding and troubleshooting.

---

# **1. Cryptographic Operations**

OpenSSL supports a wide range of cryptographic functions.

### **1.1 Hashing**
```
openssl dgst -sha256 file.txt
openssl dgst -sha512 file.txt
```

### **1.2 Symmetric Encryption / Decryption**
```
openssl enc -aes-256-cbc -salt -in file.txt -out file.enc
openssl enc -aes-256-cbc -d -in file.enc -out file.txt
```

### **1.3 Random Number Generation**
```
openssl rand -hex 32
openssl rand -base64 64
```

### **1.4 Message Digests**
```
openssl md5 file.txt
openssl sha256 file.txt
```

---

# **2. TLS / SSL Tools**

OpenSSL includes powerful tools for testing and debugging TLS connections.

### **2.1 Test a TLS Connection**
```
openssl s_client -connect example.com:443
```

### **2.2 Show Server Certificate**
```
openssl s_client -connect example.com:443 -showcerts
```

### **2.3 Test Specific TLS Versions**
```
openssl s_client -tls1_2 -connect example.com:443
openssl s_client -tls1_3 -connect example.com:443
```

### **2.4 Test Cipher Suites**
```
openssl ciphers -v
```

---

# **3. Key and Certificate Conversions**

OpenSSL can convert between multiple formats.

### **3.1 PEM ↔ DER**
```
openssl x509 -in cert.pem -outform der -out cert.der
openssl x509 -in cert.der -inform der -out cert.pem
```

### **3.2 PEM ↔ PKCS#12 (.pfx)**
```
openssl pkcs12 -export -in cert.pem -inkey key.pem -out bundle.pfx
openssl pkcs12 -in bundle.pfx -out cert.pem -clcerts -nokeys
```

### **3.3 RSA ↔ PKCS#8**
```
openssl pkcs8 -topk8 -inform PEM -outform PEM -in key.pem -out key.pk8 -nocrypt
```

---

# **4. File and Data Utilities**

### **4.1 Base64 Encoding / Decoding**
```
openssl base64 -in file.txt -out file.b64
openssl base64 -d -in file.b64 -out file.txt
```

### **4.2 Checksum Utilities**
```
openssl dgst -sha1 file.txt
openssl dgst -sha256 file.txt
```

### **4.3 Encrypt / Decrypt Arbitrary Data**
```
echo "hello" | openssl enc -aes-256-cbc -a
```

---

# **5. Certificate Inspection and Validation**

### **5.1 Inspect Certificate**
```
openssl x509 -in cert.pem -text -noout
```

### **5.2 Inspect CSR**
```
openssl req -in request.csr -text -noout
```

### **5.3 Verify Certificate Against CA**
```
openssl verify -CAfile ca-chain.crt cert.pem
```

---

# **6. Useful OpenSSL Commands (General)**

### **6.1 Generate EC Keys**
```
openssl ecparam -genkey -name prime256v1 -out ec.key
```

### **6.2 Generate DH Parameters**
```
openssl dhparam -out dhparam.pem 2048
```

### **6.3 Generate a Self‑Signed Certificate**
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

---

# **7. Learning Notes & Study Material**

- OpenSSL is far more than a PKI tool — it is a full cryptographic toolkit.  
- TLS debugging (`s_client`) is one of the most valuable troubleshooting tools in real SOC/CTI work.  
- Format conversions (PEM, DER, PKCS#12) are common when integrating with different systems.  
- Random number generation is useful for secrets, tokens, and key material.  
- Hashing and digest commands are essential for integrity checks.  
- File encryption commands are useful for secure transport of sensitive data.  
- EC keys and DH parameters are widely used in modern TLS configurations.  
- These commands are optional for the lab but valuable for real‑world PKI and security engineering.  
- Understanding these tools improves your ability to debug TLS issues across distributed systems.  
- This appendix serves as a quick reference for future projects and troubleshooting.

---

# **8. References**

- **OpenSSL Documentation (Official)**  
  [https://www.openssl.org/docs/](https://www.openssl.org/docs/)  
  (Search: OpenSSL official documentation)

- **OpenSSL Man Pages (Command Reference)**  
  `https://www.opensssl.org/docs/manmaster/man1/` [(opensssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.opensssl.org%2Fdocs%2Fmanmaster%2Fman1%2F")  
  (Search: OpenSSL command reference)

- **OpenSSL Cookbook (Feisty Duck)**  
  `https://www.feistyduck.com/library/openssl-cookbook/` [(feistyduck.com in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.feistyduck.com%2Flibrary%2Fopenssl-cookbook%2F")  
  (Search: OpenSSL Cookbook)

- **OpenSSL Wiki – Command Examples**  
  `https://wiki.openssl.org/index.php/Command_Line_Utilities` [(wiki.openssl.org in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwiki.openssl.org%2Findex.php%2FCommand_Line_Utilities")  
  (Search: OpenSSL command line utilities)

- **OpenSSL PKI Tutorial (OpenSSL Wiki)**  
  [https://wiki.openssl.org/index.php/PKI](https://wiki.openssl.org/index.php/PKI)  
  (Search: OpenSSL PKI wiki)

- **RFC 5280 – X.509 Certificate and CRL Profile**  
  [https://datatracker.ietf.org/doc/html/rfc5280](https://datatracker.ietf.org/doc/html/rfc5280)  
  (Search: RFC 5280 certificate profile)
