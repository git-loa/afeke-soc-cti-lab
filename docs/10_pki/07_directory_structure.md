
# **PKI Directory Structure**

This document describes the directory structure used for the PKI in the SOC + CTI lab.  
All PKI assets are generated and stored **locally on the VM**, not in the repository.

The PKI directory is located at:

```
/opt/pki/
```

This location keeps sensitive files separate from Elastic configuration directories and outside version control.

---

# **1. Overview of PKI Layout**

The PKI directory contains four major sections:

1. **Root CA**  
2. **Intermediate CA**  
3. **Service Certificates**  
4. **Shared Files (CA chain, supporting files)**

Each section mirrors real enterprise PKI layouts and keeps responsibilities clearly separated.

---

# **2. Root CA Directory**

Path:

```
/opt/pki/root/
```

Structure:

```
/opt/pki/root/
    private/        # Root CA private key (root-ca.key)
    certs/          # Root CA certificate (root-ca.crt)
    db/             # CA database (index.txt, serial)
    crl/            # CRL directory (unused in this lab)
    root-ca-openssl.cnf
```

Notes:

- The Root CA stays offline after signing the Intermediate CA.  
- The private key in `private/` is the most sensitive file in the PKI.  
- The `db/` directory tracks issued certificates (required by OpenSSL CA operations).

---

# **3. Intermediate CA Directory**

Path:

```
/opt/pki/intermediate/
```

Structure:

```
/opt/pki/intermediate/
    private/            # Intermediate CA private key (int-ca.key)
    certs/              # Intermediate CA certificate + CA chain
    csr/                # Intermediate CA CSR (int-ca.csr)
    db/                 # CA database (index.txt, serial)
    crl/                # CRL directory (unused in this lab)
    int-ca-openssl.cnf
```

Notes:

- The Intermediate CA performs all certificate issuance.  
- The CA chain (`ca-chain.crt`) is stored in `certs/`.  
- The Intermediate CA remains online for service certificate signing.

---

# **4. Service Certificates Directory**

Path:

```
/opt/pki/services/
```

Structure:

```
/opt/pki/services/
    elasticsearch/
        private/        # elasticsearch.key
        csr/            # elasticsearch.csr
        certs/          # elasticsearch.crt
        es-san.cnf

    kibana/
        private/
        csr/
        certs/
        kibana-san.cnf

    fleet_server/
        private/
        csr/
        certs/
        fleet-san.cnf

    logstash/
        private/
        csr/
        certs/
        logstash-san.cnf
```

Notes:

- Each service has its own isolated directory.  
- SAN templates live alongside each service’s certificate files.  
- This separation prevents configuration drift and mirrors real PKI deployments.

---

# **5. Shared Files**

Some files are used across the PKI:

```
/opt/pki/intermediate/certs/ca-chain.crt
```

This file contains:

1. Intermediate CA certificate  
2. Root CA certificate  

in that order.

Elastic Stack requires this chain for TLS validation.

---

# **6. High‑Level Directory Map**

```
/opt/pki/
│
├── root/
│   ├── private/
│   ├── certs/
│   ├── db/
│   ├── crl/
│   └── root-ca-openssl.cnf
│
├── intermediate/
│   ├── private/
│   ├── certs/
│   ├── csr/
│   ├── db/
│   ├── crl/
│   └── int-ca-openssl.cnf
│
└── services/
    ├── elasticsearch/
    ├── kibana/
    ├── fleet_server/
    └── logstash/
```

---

# **7. Learning Notes**

- The PKI directory structure mirrors real enterprise CA layouts.  
- Root CA and Intermediate CA are strictly separated for security.  
- Service certificates are isolated to avoid mixing keys and SAN files.  
- The CA chain is stored under the Intermediate CA because it is used for all signing operations.  
- Keeping PKI under `/opt/pki/` ensures it stays outside version control and Elastic configuration directories.  
- This structure supports reproducibility, clarity, and onboarding.
