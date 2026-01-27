
# **04 — Validating Kibana Security**

This note verifies that Kibana is correctly configured to use HTTPS, trusts the Elasticsearch CA chain, and can authenticate securely to Elasticsearch.  
No configuration changes happen here — this step focuses strictly on validation and troubleshooting.

After enabling TLS in Kibana, you must confirm:

- Kibana can connect to Elasticsearch over HTTPS  
- Kibana trusts the CA chain  
- Kibana presents its service certificate correctly  
- Browsers can access Kibana over HTTPS without hostname mismatch errors  
- Kibana can authenticate to Elasticsearch using the configured built‑in user  

This note walks through each validation step.

---

## **1. Validate Elasticsearch Connectivity From the Kibana Host**

Before testing Kibana itself, confirm that the Kibana server can reach Elasticsearch over HTTPS.

Run:

```
curl --cacert /etc/kibana/certs/ca-chain.crt \
  https://es.soc.cti:9200
```

Expected output:

- JSON response from Elasticsearch  
- No certificate errors  
- No hostname mismatch warnings  

Notes:

- If this fails, Kibana will not be able to start  
- SAN validation must match the hostname used in the URL  

---

## **2. Validate Kibana HTTPS in the Browser**

Open:

```
https://kibana.soc.cti:5601
```

Expected behavior:

- Browser loads the Kibana login page  
- No certificate warnings  
- Certificate details show the correct SANs  
- Issuer matches your Intermediate CA  

Notes:

- If the browser warns about hostname mismatch, the SANs in `kibana.crt` are incorrect  
- If the browser warns about untrusted CA, import the Root CA into your system trust store  

---

## **3. Validate Kibana Service Startup**

Check service status:

```
sudo systemctl status kibana
```

If Kibana is running, tail logs:

```
sudo journalctl -u kibana -f
```

Look for:

- Successful TLS handshake  
- Successful authentication to Elasticsearch  
- No errors related to certificates or authentication  

Common success indicators:

```
Kibana server is not ready yet
Kibana server is ready
```

---

## **4. Validate the Kibana Certificate**

Inspect the certificate:

```
openssl x509 -in /etc/kibana/certs/kibana.crt -text -noout
```

Confirm:

- SANs include `kibana.soc.cti`  
- Issuer is your Intermediate CA  
- Key Usage and Extended Key Usage are correct  
- Validity dates are correct  

---

## **5. Validate the Certificate Chain**

Run:

```
openssl verify \
  -CAfile /etc/kibana/certs/ca-chain.crt \
  /etc/kibana/certs/kibana.crt
```

Expected output:

```
kibana.crt: OK
```

Notes:

- If verification fails, the CA chain is incomplete or incorrect  
- The chain must include both Root and Intermediate CA certificates  

---

## **6. Common Issues and Fixes**

### **6.1 Hostname Mismatch**
Symptoms:

- Browser warning  
- Kibana logs: `Hostname mismatch`  
- Curl: `certificate subject name does not match target host name`

Fix:

- Regenerate `kibana.crt` with correct SANs  
- Ensure `/etc/hosts` resolves `kibana.soc.cti`  

---

### **6.2 Wrong CA Chain**
Symptoms:

- `unable to verify the first certificate`  
- Kibana refuses to connect to Elasticsearch  

Fix:

- Use the full CA chain (Root + Intermediate)  
- Ensure the chain is in the correct order  

---

### **6.3 Incorrect Permissions**
Symptoms:

- Kibana fails to start  
- Logs show: `EACCES: permission denied`  

Fix:

```
sudo chown -R kibana:kibana /etc/kibana/certs/
sudo chmod 600 /etc/kibana/certs/kibana.key
```

---

### **6.4 Authentication Failure**
Symptoms:

- Kibana logs: `authentication failed`  
- Kibana cannot connect to Elasticsearch  

Fix:

- Confirm the `kibana_system` password is correct  
- Ensure the user is not locked  
- Restart Kibana after updating credentials  

---

## **7. Learning Notes**

- Kibana enforces strict TLS validation — SANs must match exactly  
- The CA chain must be complete and trusted  
- Basic authentication is the correct method for Kibana → Elasticsearch in this lab  
- Most startup failures are caused by certificate permissions or SAN mismatches  
- This step confirms Kibana is fully secured and ready for use  

---

# **10. References**

- **Kibana TLS Configuration Guide**  
  `https://www.elastic.co/guide/en/kibana/current/configuring-tls.html`  
  (Search: elastic.co configuring TLS Kibana)

- **Kibana Security Settings Overview**  
  `https://www.elastic.co/guide/en/kibana/current/security-settings-kb.html`  
  (Search: elastic.co Kibana security settings)

- **Kibana System Configuration Notes**  
  `https://www.elastic.co/guide/en/kibana/current/system-config.html`  
  (Search: elastic.co Kibana system config)

- **Elastic Stack Installation Overview**  
  `https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html`  
  (Search: elastic.co install Elastic Stack)