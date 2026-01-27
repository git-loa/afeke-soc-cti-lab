
# **01 — Elasticsearch Installation (Ubuntu 22.04 / 24.04)**

This guide documents the installation of **Elasticsearch only** on Ubuntu.  
Kibana and Logstash will have their own installation notes in their respective sections.

This installation workflow is reproducible, minimal, and suitable for SOC labs, endpoint telemetry pipelines, and Elastic‑based detection engineering environments.

---

## **1. System Preparation**

Update the system and install required dependencies:

```
sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https wget curl gnupg -y
```

Notes:

- `apt-transport-https` enables secure APT downloads  
- `gnupg` is required for key verification  
- `wget` and `curl` retrieve the Elastic GPG key  

---

## **2. Add the Elastic GPG Key**

Import the official Elastic signing key and store it in the system keyring:

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch \
  | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

Notes:

- Stored under `/usr/share/keyrings/`  
- Used by APT to verify package signatures  

---

## **3. Add the Elastic APT Repository**

Register the Elastic 8.x repository:

```
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] \
https://artifacts.elastic.co/packages/8.x/apt stable main" \
| sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

Notes:

- Provides Elasticsearch and other Elastic Stack components  
- Uses the GPG key added in the previous step  

---

## **4. Install Elasticsearch**

Update package lists and install Elasticsearch:

```
sudo apt update
sudo apt install elasticsearch -y
```

Notes:

- Installation does **not** start the service automatically  
- TLS must be configured before enabling Elasticsearch  
- The service user `elasticsearch` is created automatically  
- Configuration files live under `/etc/elasticsearch/`  

---

## **5. Post‑Installation Notes**

- Certificates will later be installed into:  
  ```
  /etc/elasticsearch/certs/
  ```
- Elasticsearch will not start until TLS is configured  
- Kibana and Logstash installation steps will be documented separately  
- Elasticsearch includes a bundled OpenJDK runtime  

---

## **6. Learning Notes**

- Elasticsearch must be installed before Kibana or Fleet  
- Security (TLS + authentication) is mandatory in 8.x  
- The next step is applying your PKI certificates and enabling HTTPS  
- This installation workflow mirrors the official Elastic documentation  

---

# **10. References**

- **Elasticsearch Debian/Ubuntu Installation Guide (Elastic Docs)**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html`  
  (Search: elastic.co install Elasticsearch Debian)

- **Elastic APT Repository Setup**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo`  
  (Search: elastic.co APT repository Elasticsearch)

- **Elastic Stack Installation Overview**  
  `https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html`  
  (Search: elastic.co install Elastic Stack)

- **Elasticsearch System Configuration Notes**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html`  
  (Search: elastic.co Elasticsearch system config)

- **Elastic Security and TLS Requirements (8.x)**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html`  
  (Search: elastic.co security settings)
