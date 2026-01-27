
# **03 — Configuring TLS in Kibana**

This note enables HTTPS for Kibana and configures Kibana to authenticate securely to Elasticsearch using the certificates installed in the previous step.  
No certificate generation or copying happens here — this note focuses strictly on editing `kibana.yml` to enable TLS.

Kibana must be configured to:

- Serve its own UI over HTTPS  
- Trust the Elasticsearch CA chain  
- Present its service certificate when connecting to Elasticsearch  
- Validate Elasticsearch’s certificate using SANs  
- Authenticate to Elasticsearch using a secure built‑in user  

This note applies all required TLS settings.

---

## **1. Edit the Kibana Configuration File**

Kibana’s main configuration file is:

```
/etc/kibana/kibana.yml
```

Open it:

```
sudo nano /etc/kibana/kibana.yml
```

---

## **2. Configure Kibana’s HTTPS Server**

Add or update the following:

```
server.host: "0.0.0.0"
server.publicBaseUrl: "https://kibana.soc.cti:5601"
```

Notes:

- `server.host` controls the bind address  
- `server.publicBaseUrl` must match a SAN in `kibana.crt`  
- Browsers use this value for redirects and absolute URLs  

---

## **3. Configure Elasticsearch HTTPS Connection**

Add:

```
elasticsearch.hosts: ["https://es.soc.cti:9200"]
```

Notes:

- The hostname must match a SAN in the Elasticsearch certificate  
- Kibana will refuse to connect if SAN validation fails  

---

## **4. Configure TLS Certificate Paths**

Add:

```
elasticsearch.ssl.certificateAuthorities: ["/etc/kibana/certs/ca-chain.crt"]
elasticsearch.ssl.certificate: "/etc/kibana/certs/kibana.crt"
elasticsearch.ssl.key: "/etc/kibana/certs/kibana.key"
elasticsearch.ssl.verificationMode: full
```

Notes:

- `verificationMode: full` enforces SAN validation  
- The CA chain must include both Intermediate and Root CA  
- Kibana must be able to read the key and certificate  

---

## **5. Configure Kibana Authentication to Elasticsearch**

Kibana authenticates using a built‑in user.

Recommended:

```
elasticsearch.username: "kibana_system"
elasticsearch.password: "<your_password>"
```

Alternative (also valid in a lab):

```
elasticsearch.username: "elastic"
elasticsearch.password: "<elastic_password>"
```

Notes:

- `kibana_system` is the intended service user for Kibana  
- Passwords were created during Elasticsearch setup  
- This replaces the deprecated `kibana` user from older versions  

---

## **Note on serviceAccountToken (Optional)**

Kibana supports authenticating to Elasticsearch using a `serviceAccountToken`, but this mechanism is **optional** and not required for this lab.

Service account tokens are typically used by:

- Fleet Server  
- Elastic Agent  
- Automated machine‑to‑machine workflows  

For Kibana itself:

- Basic authentication is fully supported  
- It integrates cleanly with your PKI + TLS setup  
- It avoids unnecessary complexity for a single‑node SOC/CTI lab  

This is why this configuration uses:

```
elasticsearch.username: "kibana_system"
elasticsearch.password: "<your_password>"
```

instead of:

```
elasticsearch.serviceAccountToken: "<token>"
```

---

## **6. Restart Kibana**

Apply the configuration:

```
sudo systemctl restart kibana
sudo systemctl status kibana
```

If Kibana fails to start, check logs:

```
sudo journalctl -u kibana -f
```

---

## **7. Learning Notes**

- Kibana must trust the same CA chain used by Elasticsearch  
- SAN validation is strict — hostnames must match exactly  
- Incorrect permissions on `/etc/kibana/certs/` will prevent startup  
- Basic authentication is the correct method for Kibana → Elasticsearch  
- Service account tokens are optional and not required here  
- This step prepares Kibana for validation in the next note  

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
