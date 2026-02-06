
# **04 — Validating Elastic Agent Security and Enrollment (Linux Endpoint)**

This note documents how to validate the Elastic Agent’s security, TLS configuration, enrollment status, and policy assignment **after installation** using the **Kibana‑generated Production mode command**.

All validation steps occur **on the endpoint** or in **Kibana**.

---

## **1. Validate the Elastic Agent systemd service**

Check that the service is running:

```bash
sudo systemctl status elastic-agent
```

Expected:

- `active (running)`
- No restart loops
- No TLS or enrollment errors

Follow logs if needed:

```bash
sudo journalctl -u elastic-agent -f
```

---

## **2. Validate TLS trust on the endpoint**

Confirm Elasticsearch trust:

```bash
curl --cacert /etc/elastic-agent/certs/ca-chain.crt \
  https://es.soc.cti:9200
```

Confirm Fleet Server trust:

```bash
curl --cacert /etc/elastic-agent/certs/ca-chain.crt \
  https://fleet.soc.cti:8220
```

Expected:

- JSON response  
- No certificate errors  
- No hostname mismatch warnings  

If TLS fails, the agent will not check in.

---

## **3. Validate enrollment in Kibana**

In Kibana:

**Management → Fleet → Agents**

Expected:

- Status: **Healthy**
- Policy: your endpoint policy
- Last check‑in: recent
- Version: matches installed version
- Hostname: correct
- TLS: enabled

If the agent is **Unhealthy**, open the agent details to view logs and errors.

---

## **4. Validate policy assignment**

Open the agent in Kibana and confirm:

- The correct policy is assigned  
- Integrations appear under “Agent policy”  
- No policy errors are shown  

Reassign the policy if needed.

---

## **5. Validate data ingestion**

Check for incoming data:

- **Observability → Logs → Stream**  
- **Security → Alerts → Manage rules**

Depending on your policy, you should see:

- System logs  
- Endpoint logs  
- Metrics  
- Security events (if Endpoint Security is enabled)

If no data appears:

- Check the agent policy  
- Check Fleet Server health  
- Check endpoint logs  

---

## **6. Validate the communication path**

The full path is:

```
Elastic Agent → Fleet Server → Elasticsearch
```

### **A. Agent → Fleet Server**

Check agent logs:

```bash
sudo journalctl -u elastic-agent -f
```

Look for:

- Successful check‑ins  
- No TLS handshake errors  
- No enrollment token errors  

### **B. Fleet Server → Elasticsearch**

In Kibana:

**Management → Fleet → Fleet Servers**

Expected:

- Fleet Server status: **Healthy**
- Elasticsearch connection: **Connected**

---

## **7. Validate the agent CA configuration**

Check the CA path stored during installation:

```bash
sudo cat /opt/Elastic/Agent/elastic-agent.yml | grep certificate-authorities
```

Expected:

```
certificate-authorities: /etc/elastic-agent/certs/ca-chain.crt
```

If incorrect, TLS validation will fail.

---

## **8. Common issues and fixes**

### **A. x509: certificate signed by unknown authority**
Cause: CA chain missing or incorrect  
Fix: Re-copy `ca-chain.crt` and re-test with `curl`

### **B. TLS: hostname mismatch**
Cause: SAN mismatch  
Fix: Ensure SANs match `es.soc.cti` and `fleet.soc.cti`

### **C. Agent stuck in “Unhealthy”**
Cause: Fleet Server unreachable  
Fix: Validate Fleet Server health and TLS trust

### **D. Agent not receiving policy**
Cause: Fleet Server → Elasticsearch failure  
Fix: Validate Fleet Server TLS and connectivity

---

## **9. Learning notes**

- Elastic Agent depends entirely on Fleet Server health  
- TLS validation is strict and SAN‑based  
- Only the CA chain is required on the endpoint  
- Production mode ensures a persistent systemd service  
- Most failures are caused by:
  - missing CA chain  
  - incorrect CA chain  
  - hostname mismatch  
  - Fleet Server issues  

---

# **10. References**

- **Elastic Agent Troubleshooting**  
  `https://www.elastic.co/guide/en/fleet/current/elastic-agent-troubleshooting.html`  
  (Search: elastic.co Elastic Agent troubleshooting)

- **Elastic Agent Enrollment**  
  `https://www.elastic.co/guide/en/fleet/current/agent-enrollment.html`  
  (Search: elastic.co Elastic Agent enrollment)

- **Fleet Server Troubleshooting**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-troubleshooting.html`  
  (Search: elastic.co Fleet troubleshooting)

- **Secure Connections (TLS)**  
  `https://www.elastic.co/guide/en/fleet/current/secure-connections.html`  
  (Search: elastic.co Fleet secure connections)
