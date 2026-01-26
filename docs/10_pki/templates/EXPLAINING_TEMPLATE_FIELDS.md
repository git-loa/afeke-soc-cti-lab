
# **Explaining Template Fields**

## **Purpose**
This document explains the meaning and purpose of every field used in the PKI templates:

- `root-ca-openssl.cnf`  
- `int-ca-openssl.cnf`  
- SAN templates for service certificates  

It is written in note‑style for clarity and onboarding.

---

# **1. Understanding OpenSSL CA Templates**

OpenSSL configuration files are divided into sections.  
Each section controls a different part of the certificate creation process.

The key sections are:

- `[ ca ]`  
- `[ CA_default ]`  
- `[ policy_* ]`  
- `[ req ]`  
- `[ dn ]`  
- `[ v3_ca ]`  
- `[ v3_intermediate_ca ]`  
- `[ v3_req ]`  
- `[ san ]` / `[ alt_names ]`  

Below is a breakdown of each.

---

# **2. Section-by-Section Explanation**

---

## **[ ca ]**
Controls which CA configuration block to use.

```
[ ca ]
default_ca = CA_default
```

- Always points to the main CA settings block.
- Never changed.

---

## **[ CA_default ]**
Defines the CA’s directory structure, database, keys, and certificates.

Example fields:

```
dir               = .
certs             = $dir/certs
private_key       = $dir/private/root-ca.key
certificate       = $dir/certs/root-ca.crt
database          = $dir/db/index.txt
serial            = $dir/db/serial
default_md        = sha256
default_days      = 3650
```

### **Meaning of each field**

| Field | Purpose |
|-------|---------|
| `dir` | Base directory for CA files. Always `.` for relative paths. |
| `certs` | Where new certificates are stored. |
| `private_key` | Path to the CA’s private key. |
| `certificate` | Path to the CA’s certificate. |
| `database` | Tracks issued certificates. Required for CA operations. |
| `serial` | Tracks certificate serial numbers. |
| `default_md` | Hash algorithm (sha256 recommended). |
| `default_days` | Certificate lifetime. Root CA long, Intermediate shorter. |

### **Editable?**
- Only `default_days` is optional to change.
- Everything else must remain unchanged.

---

## **[ policy_strict ] / [ policy_loose ]**

Policies define which DN fields must be present in CSRs.

### **Root CA uses strict policy**
```
countryName = supplied
stateOrProvinceName = supplied
organizationName = supplied
commonName = supplied
```

### **Intermediate CA uses loose policy**
```
countryName = optional
stateOrProvinceName = optional
organizationName = optional
commonName = supplied
```

### **Why?**
- Root CA requires full identity.
- Intermediate CA accepts simpler CSRs from services.

### **Editable?**
No — policies must not be changed.

---

## **[ req ]**
Controls certificate request behavior.

```
default_bits        = 4096
default_md          = sha256
prompt              = no
distinguished_name  = dn
x509_extensions     = v3_ca
```

### **Meaning**
| Field | Purpose |
|-------|---------|
| `default_bits` | Key size (4096 recommended). |
| `prompt` | `no` means DN fields come from `[ dn ]`. |
| `distinguished_name` | Points to the `[ dn ]` section. |
| `x509_extensions` | Extensions applied to self‑signed Root CA. |

### **Editable?**
- No — except key size if you intentionally want smaller keys.

---

## **[ dn ]**
Defines the certificate’s subject (identity).

```
C  = CA
ST = Root-State
O  = Root-Org
CN = Root-CA
```

### **Meaning**
| Field | Purpose |
|-------|---------|
| `C` | Country code (2 letters). |
| `ST` | State or province. |
| `O` | Organization name. |
| `CN` | Common Name (Root CA or Intermediate CA). |

### **Editable?**
**Yes — these are the main fields you customize.**

---

## **[ v3_ca ]**
Extensions for the Root CA certificate.

```
basicConstraints = critical, CA:TRUE
keyUsage         = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always
```

### **Meaning**
| Extension | Purpose |
|-----------|---------|
| `CA:TRUE` | Marks certificate as a CA. |
| `keyCertSign` | Allows signing other certificates. |
| `cRLSign` | Allows signing CRLs. |
| `subjectKeyIdentifier` | Identifies this key. |
| `authorityKeyIdentifier` | Identifies issuer (self for Root CA). |

### **Editable?**
**No — changing these breaks the CA.**

---

## **[ v3_intermediate_ca ]**
Extensions for Intermediate CA certificate.

```
basicConstraints = critical, CA:TRUE, pathlen:0
```

### **Meaning**
| Field | Purpose |
|-------|---------|
| `pathlen:0` | Intermediate CA cannot create further sub‑CAs. |

### **Editable?**
No — must remain exactly as-is.

---

## **[ v3_req ]**
Extensions applied to Intermediate CA CSR.

```
basicConstraints = CA:TRUE, pathlen:0
```

### **Meaning**
- Ensures the CSR requests CA capabilities.
- Root CA will override/extend these when signing.

### **Editable?**
No.

---

# **3. SAN Templates Explanation**

SAN templates define Subject Alternative Names for service certificates.

Example:

```
[ san ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = elasticsearch
DNS.2 = localhost
IP.1  = 127.0.0.1
```

### **Meaning**
| Field | Purpose |
|-------|---------|
| `DNS.x` | Hostnames the certificate is valid for. |
| `IP.x` | IP addresses the certificate is valid for. |

### **Editable?**
**Yes — these must match your actual hostnames and IPs.**

### **Rules**
- Order does not matter.
- Numbers must increment (`DNS.1`, `DNS.2`, `DNS.3`, …).
- SANs must match what Elastic services use to connect.

---

# **4. Summary of Editable Fields**

### **Root CA**
- `C`, `ST`, `O`, `CN`
- `default_days` (optional)

### **Intermediate CA**
- `C`, `ST`, `O`, `CN`
- `default_days` (optional)

### **SAN Templates**
- All `DNS.x` values  
- All `IP.x` values  

### **Everything else must remain unchanged.**

---

# **5. Why This Matters**

Understanding these fields helps you:

- avoid misconfigured certificates  
- maintain a clean PKI hierarchy  
- troubleshoot TLS issues  
- onboard new contributors  
- ensure reproducibility  
- align with industry PKI standards  

This file acts as a reference for anyone modifying or extending the PKI.
