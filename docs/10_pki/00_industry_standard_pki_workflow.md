
# **Industry‑Standard PKI Workflow**

This document describes the PKI workflow used to secure all communication inside the SOC + CTI lab.  
The workflow follows enterprise practices and is adapted for a single‑VM Elastic Stack deployment.

All PKI assets are generated and stored **locally on the VM** under:

```
/opt/pki/
```

This directory is **not** part of the repository and must never be committed.

---

# 1. Purpose of PKI in This Lab

PKI is used to:

- secure communication between Elastic components  
- authenticate services  
- validate trust between endpoints  
- enable HTTPS for Elasticsearch and Kibana  
- enable secure enrollment for Elastic Agents  
- secure Logstash → Elasticsearch communication  

All components must trust the same certificate authority (CA).

---

# 2. PKI Directory Structure (On the VM)

All PKI assets are stored under:

```
/opt/pki/
```

Recommended structure:

```
/opt/pki/
    root/
    intermediate/
    services/
    chains/
```

This location is:

- root‑owned  
- outside Elastic installation directories  
- outside user home directories  
- easy to secure  
- easy to reference in documentation  

No PKI files are stored in the repository.

---

# 3. PKI Structure

The PKI consists of:

1. **Root CA**  
   - Highest trust anchor  
   - Used only to sign the Intermediate CA  
   - Stored in `/opt/pki/root/`

2. **Intermediate CA**  
   - Signs all service certificates  
   - Stored in `/opt/pki/intermediate/`

3. **Service Certificates**  
   - One certificate per service  
   - Includes SANs (hostnames and IPs)  
   - Stored in `/opt/pki/services/<service>/`

4. **CA Chain**  
   - Intermediate CA certificate  
   - Root CA certificate  
   - Stored in `/opt/pki/chains/`

---

# 4. Important Clarification: Fleet vs Fleet Server

There are two different components named “Fleet”:

## 4.1 Fleet Server (Service)
- Runs on the Elastic Stack VM  
- Installed by running Elastic Agent in Fleet Server mode  
- Requires its own **service certificate**  
- Used as the enrollment endpoint for Elastic Agents  
- Communicates with Elasticsearch over TLS  

## 4.2 Fleet (Management UI in Kibana)
- A feature inside Kibana  
- Used to manage Elastic Agents and policies  
- Does not run as a separate service  
- Does not require its own certificate  
- Uses Kibana’s TLS configuration  

Only **Fleet Server** receives a certificate.

---

# 5. Standard PKI Workflow

## Step 1: Create Root CA
Stored in:

```
/opt/pki/root/
```

- Generate private key  
- Generate self‑signed Root CA certificate  
- Used only to sign the Intermediate CA  

---

## Step 2: Create Intermediate CA
Stored in:

```
/opt/pki/intermediate/
```

- Generate private key  
- Generate CSR  
- Sign CSR with Root CA  
- Produces Intermediate CA certificate  

---

## Step 3: Create Service Certificate CSRs
Stored in:

```
/opt/pki/services/<service>/
```

Generate a private key and CSR for each service:

- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

Elastic Agents do not receive certificates; they only need the CA chain.

Each CSR must include:

- Common Name (CN)  
- SANs (hostnames and IPs)  
- Key usage fields  

---

## Step 4: Sign Service Certificates with Intermediate CA
- Use Intermediate CA to sign each CSR  
- Produce a certificate for each service  
- Ensure SANs match actual hostnames and IPs  

---

## Step 5: Build the CA Chain
Stored in:

```
/opt/pki/chains/ca-chain.crt
```

Concatenate:

1. Intermediate CA certificate  
2. Root CA certificate  

---

## Step 6: Distribute Certificates and Keys to Services

Certificates are copied from `/opt/pki/` into the appropriate Elastic service directories:

- `/etc/elasticsearch/`  
- `/etc/kibana/`  
- `/etc/fleet-server/`  
- `/etc/logstash/`  

Elastic Agents only receive the CA chain.

---

## Step 7: Apply Certificates to Elastic Components

### Elasticsearch
- HTTPS enabled  
- Node certificate + key  
- CA chain  

### Kibana
- HTTPS enabled  
- Certificate + key  
- CA chain to trust Elasticsearch  

### Fleet Server
- Certificate + key  
- CA chain to trust Elasticsearch  

### Elastic Agent
- Uses CA chain to trust Fleet Server  
- Does not receive its own certificate  

### Logstash
- Certificate + key  
- CA chain to trust Elasticsearch  

---

# 6. Validation Checklist

Before moving on:

- Root CA created in `/opt/pki/root/`  
- Intermediate CA created in `/opt/pki/intermediate/`  
- Service CSRs generated in `/opt/pki/services/`  
- Service certificates signed  
- CA chain built in `/opt/pki/chains/`  
- SANs match hostnames and IPs  
- Fleet Server certificate created (not Fleet UI)  
- No private keys are mixed between services  
- No PKI files committed to the repository  

If all items are complete, proceed to Elasticsearch installation.

---

# 7. References

1. Elastic. “Configuring TLS for Elasticsearch.”  
   `https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html`

2. Elastic. “Security Settings in Elasticsearch.”  
   `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html`

3. Fleet and Elastic Agent Overview.  
   `https://www.elastic.co/guide/en/fleet/current/fleet-overview.html`

4. Logstash Security and TLS.  
   `https://www.elastic.co/guide/en/logstash/current/ls-security.html`

5. OpenSSL Documentation.  
   `https://www.openssl.org/docs/`
