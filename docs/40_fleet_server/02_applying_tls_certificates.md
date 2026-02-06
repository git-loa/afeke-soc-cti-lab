
# **02 — Applying TLS Certificates to Fleet Server**

This note copies the PKI‑generated certificates into the Fleet Server directory, applies secure permissions, and verifies the certificate chain.  
No Fleet Server enrollment or configuration happens here — that is covered in the next note.

Fleet Server runs on the **same VM** as Elasticsearch and Kibana in this lab.

---

## **1. Create the Certificate Directory**

Fleet Server expects its certificates under:

```
/etc/fleet-server/certs/
```

Create the directory:

```
sudo mkdir -p /etc/fleet-server/certs
```

---

## **2. Copy the Certificates**

Copy the following files from your PKI output:

- `fleet-server.crt`  
- `fleet-server.key`  
- `ca-chain.crt` (Root + Intermediate CA)

Example:

```
sudo cp /opt/pki/intermediate/services/fleet/certs/fleet-server.crt /etc/fleet-server/certs/
sudo cp /opt/pki/intermediate/services/fleet/private/fleet-server.key /etc/fleet-server/certs/
sudo cp /otp/pki/intermediate/certs/ca-chain.crt /etc/fleet-server/certs/
```

Adjust paths if your PKI output directory differs.

---

## **3. Apply Secure Permissions**

To stay consistent with your Elasticsearch and Kibana modules, use:

```
sudo chmod 750 /etc/fleet-server/certs/
sudo chmod 600 /etc/fleet-server/certs/fleet-server.key
sudo chmod 644 /etc/fleet-server/certs/fleet-server.crt
sudo chmod 644 /etc/fleet-server/certs/ca-chain.crt
```

Notes:

- `fleet-server.key` must be readable only by root  
- Certificates (`.crt`) can be world‑readable  
- `750` matches your existing TLS directory permissions across the stack  

---

## **4. Validate the Certificate**

Inspect the Fleet Server certificate:

```
openssl x509 -in /etc/fleet-server/certs/fleet-server.crt -text -noout
```

Confirm:

- SANs include the Fleet Server hostname (e.g., `fleet.soc.cti`)  
- Issuer is your Intermediate CA  
- Key Usage and Extended Key Usage are correct  
- Validity dates are correct  

---

## **5. Validate the Certificate Chain**

Verify that the certificate chains correctly to your Root + Intermediate CA:

```
openssl verify \
  -CAfile /etc/fleet-server/certs/ca-chain.crt \
  /etc/fleet-server/certs/fleet-server.crt
```

Expected output:

```
fleet-server.crt: OK
```

If verification fails:

- The CA chain is incomplete or out of order  
- The certificate was signed by the wrong Intermediate CA  
- The SANs may not match the intended hostname  

---

## **6. Learning Notes**

- Fleet Server requires TLS for all inbound and outbound connections  
- The certificate must include SANs for the Fleet Server hostname  
- The CA chain must include both Root and Intermediate CA  
- Permissions must be correct before running the Kibana‑generated enrollment command  
- This step prepares the VM for Fleet Server configuration in the next note  

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
