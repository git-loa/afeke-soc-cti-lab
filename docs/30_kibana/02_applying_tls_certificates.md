
# **02 — Applying TLS Certificates to Kibana**

This note focuses **only** on installing the PKI‑generated certificates into Kibana’s directory structure, setting permissions, and verifying the files.  
No configuration changes happen here — that will be the next note.

This step installs the service certificate, private key, and CA chain into Kibana’s configuration directory.  
These files were generated earlier under `/opt/pki/services/kibana/` and must now be placed where Kibana can access them securely.

---

## **1. Create the Kibana Certificate Directory**

Kibana expects certificates under:

```
/etc/kibana/certs/
```

Create the directory if it does not exist:

```
sudo mkdir -p /etc/kibana/certs
```

---

## **2. Copy the TLS Files From the PKI Workspace**

Source directory:

```
/opt/pki/services/kibana/
```

Copy the required files:

```
sudo cp /opt/pki/services/kibana/private/kibana.key /etc/kibana/certs/
sudo cp /opt/pki/services/kibana/certs/kibana.crt /etc/kibana/certs/
sudo cp /opt/pki/intermediate/certs/ca-chain.crt /etc/kibana/certs/
```

Notes:

- The CA chain is shared across all services and stored under the Intermediate CA  
- Only the service key and certificate come from the Kibana service directory  

---

## **3. Set Correct Permissions**

Kibana requires strict permissions on private keys and controlled access to the certificate directory.

Apply file permissions:

```
sudo chmod 600 /etc/kibana/certs/kibana.key
sudo chmod 644 /etc/kibana/certs/kibana.crt
sudo chmod 644 /etc/kibana/certs/ca-chain.crt
```

Set directory permissions:

```
sudo chmod 750 /etc/kibana/certs
```

Set ownership:

```
sudo chown -R kibana:kibana /etc/kibana/certs/
```

Notes:

- The `kibana` user must be able to read the private key  
- Other users must not have access to the key  
- Incorrect permissions will prevent Kibana from starting  

---

## **4. Verify the Certificate Against the CA Chain**

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

- Confirms the certificate was signed by the Intermediate CA  
- The CA chain must include both Intermediate and Root CA certificates  

---

## **5. Directory Structure After Installation**

```
/etc/kibana/
    certs/
        kibana.key
        kibana.crt
        ca-chain.crt
```

This directory is now ready for TLS configuration in `kibana.yml`.

---

## **6. Learning Notes**

- Kibana does not read certificates from `/opt/pki`  
- `/opt/pki` remains your CA workspace and must be preserved  
- `/etc/kibana/certs/` contains only runtime files  
- Permissions are critical — incorrect permissions will prevent Kibana from starting  
- This step prepares the environment for enabling HTTPS in the next note  

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

- **Elastic Stack Certificate Management Concepts**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html`  
  (Search: elastic.co certificate management Elastic Stack)

- **Kibana Debian/Ubuntu Installation Guide**  
  `https://www.elastic.co/guide/en/kibana/current/deb.html`  
  (Search: elastic.co install Kibana Debian)
