
# **02 — Applying TLS Certificates to Elasticsearch**

This note focuses **only** on installing the PKI‑generated certificates into Elasticsearch’s directory structure, setting permissions, and verifying the files.  
No configuration changes happen here — that will be the next note.

This step installs the service certificate, private key, and CA chain into Elasticsearch’s configuration directory.  
These files were generated earlier under `/opt/pki/services/elasticsearch/` and must now be placed where Elasticsearch can access them securely.

---

## **1. Create the Elasticsearch Certificate Directory**

Elasticsearch expects certificates under:

```
/etc/elasticsearch/certs/
```

Create the directory if it does not exist:

```
sudo mkdir -p /etc/elasticsearch/certs
```

---

## **2. Copy the TLS Files From the PKI Workspace**

Source directory:

```
/opt/pki/services/elasticsearch/
```

Copy the required files:

```
sudo cp /opt/pki/services/elasticsearch/private/elasticsearch.key /etc/elasticsearch/certs/
sudo cp /opt/pki/services/elasticsearch/certs/elasticsearch.crt /etc/elasticsearch/certs/
sudo cp /opt/pki/intermediate/certs/ca-chain.crt /etc/elasticsearch/certs/
```

Notes:

- The CA chain is shared across all services and stored under the Intermediate CA  
- Only the service key and certificate come from the service directory  

---

## **3. Set Correct Permissions**

Elasticsearch requires strict permissions on private keys and controlled access to the certificate directory.

Apply file permissions:

```
sudo chmod 600 /etc/elasticsearch/certs/elasticsearch.key
sudo chmod 644 /etc/elasticsearch/certs/elasticsearch.crt
sudo chmod 644 /etc/elasticsearch/certs/ca-chain.crt
```

Set directory permissions:

```
sudo chmod 750 /etc/elasticsearch/certs
```

Set ownership:

```
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/certs/
```

Notes:

- The `elasticsearch` user must be able to read the key  
- Other users must not have access to the private key  
- Incorrect permissions will prevent Elasticsearch from starting  

---

## **4. Verify the Certificate Against the CA Chain**

Run:

```
openssl verify \
  -CAfile /etc/elasticsearch/certs/ca-chain.crt \
  /etc/elasticsearch/certs/elasticsearch.crt
```

Expected output:

```
elasticsearch.crt: OK
```

Notes:

- This confirms the certificate was signed by the Intermediate CA  
- The chain must contain both Intermediate and Root CA certificates  

---

## **5. Directory Structure After Installation**

```
/etc/elasticsearch/
    certs/
        elasticsearch.key
        elasticsearch.crt
        ca-chain.crt
```

This directory is now ready for TLS configuration in `elasticsearch.yml`.

---

## **6. Learning Notes**

- Elasticsearch does not read certificates from `/opt/pki`  
- `/opt/pki` remains your CA workspace and must be preserved  
- `/etc/elasticsearch/certs/` contains only runtime files  
- Permissions are critical — incorrect permissions will prevent Elasticsearch from starting  
- This step prepares the environment for enabling HTTPS in the next note  

---

# **10. References**

- **Elastic TLS Configuration Guide**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html`  
  (Search: elastic.co configuring TLS)

- **Elasticsearch Security Settings Overview**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html`  
  (Search: elastic.co security settings)

- **Elasticsearch File Permissions Requirements**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/setting-file-permissions.html`  
  (Search: elastic.co file permissions)

- **Elasticsearch Debian/Ubuntu Installation Guide**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html`  
  (Search: elastic.co install Elasticsearch Debian)
