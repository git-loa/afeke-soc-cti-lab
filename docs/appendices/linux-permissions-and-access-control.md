
# **Linux Permissions & Access Control for Secure SOC/CTI Environments**

This appendix provides a clear, security‑focused reference for Linux permissions, access control models, and how they apply to SOC/CTI labs, PKI workflows, and Elastic Stack services.

---

## **1. Linux Permission Model (DAC)**

Linux uses **Discretionary Access Control (DAC)** by default.  
Every file and directory has:

- **Owner**
- **Group**
- **Others**

Each permission digit is a sum of:

- **4** = read  
- **2** = write  
- **1** = execute  

Examples:

- **7 = 4+2+1 = rwx**
- **6 = 4+2 = rw-**
- **5 = 4+1 = r-x**
- **0 = ---**

DAC is the foundation of Linux security and is used throughout your SOC/CTI lab.

---

## **2. Complete Permission Mode Table (000–777)**

| Mode | Meaning | Security Use Case |
|------|---------|-------------------|
| **000** | no access | disable access completely |
| **400** | owner read | sensitive configs |
| **440** | owner+group read | shared read‑only secrets |
| **444** | world read | public certs, docs |
| **600** | owner read/write | private keys, tokens |
| **640** | owner rw, group r | service configs |
| **644** | owner rw, world r | public certs, non‑sensitive configs |
| **660** | owner+group rw | shared writable files |
| **700** | owner rwx | private directories, PKI |
| **750** | owner rwx, group rx | service directories |
| **755** | owner rwx, world rx | system binaries, public dirs |
| **770** | owner+group rwx | shared team dirs |
| **775** | owner+group rwx, world rx | collaborative scripts |
| **777** | everyone rwx | never use in security contexts |

---

## **3. Choosing the Right Permission Mode (Security‑First)**

### **Use 600 for:**
- private keys (`*.key`)
- API tokens
- service credentials
- sensitive secrets

### **Use 640 for:**
- service configuration files
- files readable by a service group

### **Use 644 for:**
- public certificates (`*.crt`)
- non‑sensitive configuration files
- documentation

### **Use 700 for:**
- PKI working directories
- root‑only directories
- sensitive application data

### **Use 750 for:**
- service data directories
- directories where only the service user + root should access

### **Use 755 for:**
- system directories
- public binaries
- directories containing non‑sensitive files

### **Never use 777**
- full compromise risk
- allows arbitrary file replacement or malicious injection

---

## **4. Directory vs File Permissions**

### **Files**
- `r` = read file contents  
- `w` = modify file  
- `x` = execute file  

### **Directories**
- `r` = list files  
- `x` = traverse directory  
- `w` = create/delete files  

A directory must have **x** for a user to access files inside it.

Example:

```
/etc/elastic-agent/certs/ca-chain.crt → 644
/etc/elastic-agent/certs/             → must be 755 or 750
```

Without directory execute permission, curl cannot read the file.

---

## **5. Service Accounts and Permissions**

Linux services run under dedicated users:

- `elasticsearch`
- `kibana`
- `fleet-server`
- `elastic-agent`

These users require:

- read access to their own certificates  
- write access to their own data directories  
- no access to other services’ secrets  

**Example: Fleet Server**

```
/etc/fleet-server/certs/fleet-server.key → 600
/var/lib/fleet-server/                  → 750
```

This prevents cross‑service compromise.

---

## **6. How DAC, MAC, and RBAC Fit Together**

### **DAC (Discretionary Access Control)**  
Default Linux filesystem model.

- Controlled by `chmod`, `chown`, `chgrp`
- Owner decides access
- Used for PKI, Elastic Stack, and endpoint permissions

### **MAC (Mandatory Access Control)**  
Examples: **SELinux**, **AppArmor**

- System‑wide security policies  
- Can restrict even root  
- Optional in labs, common in production  

### **RBAC (Role‑Based Access Control)**  
Not a filesystem model.

Used by:

- Elasticsearch roles  
- Kubernetes  
- IAM systems  

Controls **what actions a user can perform**, not file access.

---

## **7. How This Applies to SOC/CTI Labs**

| Layer | Model | Purpose |
|-------|--------|---------|
| **Linux filesystem** | DAC | File/directory access |
| **Elastic services** | RBAC | API and cluster actions |
| **OS security modules** | MAC | Optional sandboxing |
| **PKI** | Trust model | TLS identity and validation |

Your lab uses:

- **DAC** for file permissions  
- **RBAC** inside Elasticsearch  
- **PKI** for TLS  
- **MAC** only if you enable SELinux/AppArmor  

---

## **8. Practical Examples (PKI + Elastic Stack)**

### **Private key**
```
/etc/fleet-server/certs/fleet-server.key → 600
```

### **Public certificate**
```
/etc/elastic-agent/certs/ca-chain.crt → 644
```

### **Service directory**
```
/var/lib/elasticsearch/ → 750
```

### **System binaries**
```
/usr/bin/ → 755
```

### **PKI workspace**
```
/opt/pki/ → 700
```

---

## **9. Summary**

- **600** → private file  
- **644** → public file  
- **700** → private directory  
- **750** → service directory  
- **755** → public directory  
- **DAC** = Linux filesystem permissions  
- **MAC** = SELinux/AppArmor (optional)  
- **RBAC** = Elasticsearch/Kibana roles  
- **CA chain is public** and safe to distribute  
