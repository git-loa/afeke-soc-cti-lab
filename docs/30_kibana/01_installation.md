
# **01_installation.md — Kibana Installation**

## **1. Overview**
Kibana provides the web interface for interacting with Elasticsearch.  
This note covers:

- Installing Kibana from the Elastic APT repository  
- Preparing the systemd service  
- Creating the certificate directory  
- Ensuring correct ownership and permissions  

TLS configuration and certificate application are handled in later notes.

---

## **2. Install Kibana**

### **2.1 Update package index**
```bash
sudo apt update
```

### **2.2 Install Kibana**
```bash
sudo apt install kibana
```

This installs:

- Kibana binaries  
- Systemd service unit  
- Default configuration at `/etc/kibana/kibana.yml`

---

## **3. Enable and stop the service**

Enable Kibana to start automatically:

```bash
sudo systemctl enable kibana
```

Stop the service before configuration:

```bash
sudo systemctl stop kibana
```

Kibana must remain stopped until TLS certificates and configuration are applied.

---

## **4. Create certificate directory**

Kibana requires its own certificate, key, and the CA chain.  
Create a dedicated directory:

```bash
sudo mkdir -p /etc/kibana/certs
sudo chown -R kibana:kibana /etc/kibana/certs
```

This directory will later contain:

- `kibana.key`  
- `kibana.crt`  
- `ca-chain.crt`

---

## **5. Notes**

- Kibana runs as the `kibana` system user.  
- The certificate directory must be owned by `kibana` to avoid permission errors.  
- No TLS configuration is applied at this stage — this note focuses only on installation and preparation.  
- The next note covers applying certificates.

---

# **10. References**

- **Kibana Debian/Ubuntu Installation Guide (Elastic Docs)**  
  `https://www.elastic.co/guide/en/kibana/current/deb.html`  
  (Search: elastic.co install Kibana Debian)

- **Elastic APT Repository Setup for Kibana**  
  `https://www.elastic.co/guide/en/kibana/current/deb.html#deb-repo`  
  (Search: elastic.co APT repository Kibana)

- **Kibana System Configuration Notes**  
  `https://www.elastic.co/guide/en/kibana/current/system-config.html`  
  (Search: elastic.co Kibana system config)

- **Kibana Security and TLS Requirements (8.x)**  
  `https://www.elastic.co/guide/en/kibana/current/security-settings-kb.html`  
  (Search: elastic.co Kibana security settings)

- **Elastic Stack Installation Overview**  
  `https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html`  
  (Search: elastic.co install Elastic Stack)
