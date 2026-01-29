
# **04 — Validating Fleet Server Security**

This note verifies that Fleet Server is correctly installed, running over HTTPS, trusts the Elasticsearch CA chain, and can authenticate securely to Elasticsearch.  
No configuration changes happen here — this step focuses strictly on validation and troubleshooting.

---

## **1. Validate Fleet Server Service Status**

Check that the Elastic Agent service (which runs Fleet Server) is active:

```
sudo systemctl status elastic-agent
```

Expected:

- `active (running)`  
- No TLS or enrollment errors  

If needed, follow logs:

```
sudo journalctl -u elastic-agent -f
```

Look for:

- Successful Fleet Server startup  
- Successful connection to Elasticsearch  
- No certificate or token errors  

---

## **2. Validate Fleet Server HTTPS Endpoint**

Test Fleet Server’s HTTPS listener:

```
curl --cacert /etc/fleet-server/certs/ca-chain.crt \
  https://fleet.soc.cti:8220
```

Expected:

- JSON response indicating Fleet Server is running  
- No certificate errors  
- No hostname mismatch warnings  

Notes:

- The hostname must match a SAN in `fleet-server.crt`  
- The CA chain must include both Root and Intermediate CA  

---

## **3. Validate Elasticsearch Connectivity From Fleet Server**

Fleet Server must reach Elasticsearch over HTTPS.

Test:

```
curl --cacert /etc/fleet-server/certs/ca-chain.crt \
  https://es.soc.cti:9200
```

Expected:

- JSON response from Elasticsearch  
- No TLS errors  

If this fails, Fleet Server cannot enroll agents.

---

## **4. Validate Fleet Server in the Kibana UI**

Open:

**Management → Fleet → Fleet Servers**

Expected:

- Status: **Healthy**  
- Host: `fleet.soc.cti`  
- Port: `8220`  
- TLS: **Enabled**  
- Last check‑in: recent  

If Fleet Server shows **Unhealthy**, check:

- certificate paths  
- service token  
- Elasticsearch connectivity  
- SAN validation  

---

## **5. Validate the Fleet Server Certificate**

Inspect the certificate:

```
openssl x509 -in /etc/fleet-server/certs/fleet-server.crt -text -noout
```

Confirm:

- SANs include `fleet.soc.cti`  
- Issuer is your Intermediate CA  
- Key Usage and Extended Key Usage are correct  
- Validity dates are correct  

---

## **6. Validate the Certificate Chain**

Verify the certificate chains correctly:

```
openssl verify \
  -CAfile /etc/fleet-server/certs/ca-chain.crt \
  /etc/fleet-server/certs/fleet-server.crt
```

Expected:

```
fleet-server.crt: OK
```

If verification fails:

- The CA chain is incomplete  
- The chain is in the wrong order  
- The certificate was signed by the wrong Intermediate CA  

---

## **7. Common Issues and Fixes**

### **7.1 Hostname Mismatch**
Symptoms:

- Curl: `certificate subject name does not match target host name`  
- Fleet logs: TLS handshake failure  

Fix:

- Regenerate `fleet-server.crt` with correct SANs  
- Ensure `/etc/hosts` resolves `fleet.soc.cti`  

---

### **7.2 Wrong CA Chain**
Symptoms:

- `unable to verify the first certificate`  
- Fleet Server cannot connect to Elasticsearch  

Fix:

- Use the full CA chain (Root + Intermediate)  
- Ensure correct order: **Intermediate → Root**  

---

### **7.3 Incorrect Permissions**
Symptoms:

- Fleet Server fails to start  
- Logs show: `permission denied`  

Fix:

```
sudo chmod 750 /etc/fleet-server/certs/
sudo chmod 600 /etc/fleet-server/certs/fleet-server.key
```

---

### **7.4 Invalid or Missing Service Token**
Symptoms:

- Fleet Server logs: `authentication failed`  
- Fleet Server shows as Unhealthy in Kibana  

Fix:

- Generate a new Fleet Server service token in Kibana  
- Re-run the enrollment command  

---

## **8. Learning Notes**

- Fleet Server enforces strict TLS validation  
- SANs must match exactly  
- The CA chain must include both Root and Intermediate CA  
- The service token is required for Elasticsearch authentication  
- Most issues arise from certificate paths, permissions, or SAN mismatches  
- This step confirms Fleet Server is fully secured and ready to enroll Elastic Agents  

---

# **10. References**

- **Fleet Server TLS Requirements**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server-tls.html`  
  (Search: elastic.co Fleet Server TLS)

- **Fleet Server Deployment Scenarios**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server-deployment.html`  
  (Search: elastic.co Fleet Server deployment)

- **Elastic Agent and Fleet Security**  
  `https://www.elastic.co/guide/en/fleet/current/secure-connections.html`  
  (Search: elastic.co Fleet secure connections)

- **Fleet Server Troubleshooting**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-troubleshooting.html`  
  (Search: elastic.co Fleet troubleshooting)
