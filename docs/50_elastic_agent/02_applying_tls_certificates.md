
# **02 — Applying TLS Certificates on the Linux Endpoint**

This note documents how to apply the **PKI CA chain** to the Linux endpoint before installing Elastic Agent.  
The endpoint must trust the same Root + Intermediate CA used by Elasticsearch, Kibana, and Fleet Server.

No agent installation happens here — this step prepares the endpoint for secure enrollment.

---

## **1. Create a directory for the CA chain**

Create a directory to store the CA chain:

```bash
sudo mkdir -p /etc/elastic-agent/certs
sudo chown -R root:root /etc/elastic-agent
sudo chmod 755 /etc/elastic-agent
sudo chmod 755 /etc/elastic-agent/certs
```

This directory will hold:

- `ca-chain.crt` (Root + Intermediate CA)

---

## **2. Copy the CA chain from the Fleet Server VM**

If the CA chain already exists on the Fleet Server VM, copy it to the endpoint.

### **Option A — Using scp**

```bash
scp <user>@<fleet-server-ip>:/etc/fleet-server/certs/ca-chain.crt \
    /tmp/ca-chain.crt
sudo mv /tmp/ca-chain.crt /etc/elastic-agent/certs/
```

### **Option B — Using ssh (no temporary file)**

```bash
ssh <user>@<fleet-server-ip> "cat /etc/fleet-server/certs/ca-chain.crt" \
  | sudo tee /etc/elastic-agent/certs/ca-chain.crt > /dev/null
```

---

## **3. Apply secure permissions**

```bash
sudo chown root:root /etc/elastic-agent/certs/ca-chain.crt
sudo chmod 644 /etc/elastic-agent/certs/ca-chain.crt
```

Notes:

- The CA chain is public and can be world‑readable  
- The directory must be world‑executable (`755`) so Elastic Agent can traverse it  

---

## **4. Validate the CA chain format**

```bash
openssl x509 -in /etc/elastic-agent/certs/ca-chain.crt -text -noout
```

Confirm:

- Two certificates (Intermediate + Root)  
- Correct issuer/subject relationships  
- Valid validity dates  

---

## **5. Validate TLS trust for Elasticsearch**

```bash
curl --cacert /etc/elastic-agent/certs/ca-chain.crt \
  https://es.soc.cti:9200
```

Expected:

- JSON response  
- No certificate errors  

---

## **6. Validate TLS trust for Fleet Server**

```bash
curl --cacert /etc/elastic-agent/certs/ca-chain.crt \
  https://fleet.soc.cti:8220
```

Expected:

- JSON response  
- No TLS handshake errors  

If this fails, Elastic Agent enrollment will fail.

---

## **7. Learning notes**

- The endpoint must trust the same CA chain as the rest of the stack  
- TLS validation is strict — SANs must match exactly  
- Only the CA chain is required on the endpoint  
- This step ensures secure communication during enrollment  

---

# **10. References**

- **Elastic Agent Secure Connections (TLS)**  
  `https://www.elastic.co/guide/en/fleet/current/secure-connections.html`  
  (Search: elastic.co Fleet secure connections)

- **Fleet Server TLS Requirements**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server-tls.html`  
  (Search: elastic.co Fleet Server TLS)

- **Elastic Agent Enrollment**  
  `https://www.elastic.co/guide/en/fleet/current/agent-enrollment.html`  
  (Search: elastic.co Elastic Agent enrollment)

- **Elastic Agent Troubleshooting**  
  `https://www.elastic.co/guide/en/fleet/current/elastic-agent-troubleshooting.html`  
  (Search: elastic.co Elastic Agent troubleshooting)
