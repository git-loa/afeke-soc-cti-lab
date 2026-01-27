
# **20 — Elasticsearch**

This folder contains all documentation, procedures, and templates required to install Elasticsearch, apply PKI‑generated TLS certificates, configure secure HTTPS and transport‑layer encryption, and validate that security is correctly enforced.

The goal of this module is to provide a **reproducible, onboarding‑friendly** workflow for deploying a secure Elasticsearch instance within the SOC/CTI lab.

---

## **Folder Structure**

```
20_elasticsearch/
│
│   01_installation.md
│   02_applying_tls_certificates.md
│   03_elasticsearch_tls_configuration.md
│   04_validating_elasticsearch_security.md
│
└───templates/
        curl_validation_commands.sh
        elasticsearch.yml.template
        openssl_validation_commands.sh
        permissions_checklist.txt
        systemd_notes.txt
        tls_file_layout.txt
```

---

## **File Overview**

### **01_installation.md**  
Instructions for installing Elasticsearch on Ubuntu/Debian, including repository setup, package installation, and service initialization.

### **02_applying_tls_certificates.md**  
Steps for copying PKI‑generated certificates into `/etc/elasticsearch/certs/`, applying strict permissions, and verifying the certificate chain.

### **03_elasticsearch_tls_configuration.md**  
Configuration of HTTPS and transport‑layer TLS in `elasticsearch.yml`, including security settings required for Elasticsearch 8.x.

### **04_validating_elasticsearch_security.md**  
Validation steps confirming that HTTPS, certificate verification, authentication, and transport‑layer TLS are functioning correctly.

---

## **Templates**

The `templates/` directory contains reusable scaffolding for rebuilding Elasticsearch securely and consistently.

### **curl_validation_commands.sh**  
Script for validating HTTPS connectivity, certificate verification, and rejection of plaintext HTTP.

### **elasticsearch.yml.template**  
Minimal, production‑aligned TLS configuration template with placeholders for cluster and node information.

### **openssl_validation_commands.sh**  
Commands for verifying certificates, inspecting certificate details, and validating transport‑layer TLS on port 9300.

### **permissions_checklist.txt**  
Strict permissions model for Elasticsearch TLS files and directories.

### **systemd_notes.txt**  
Operational reference for managing Elasticsearch via systemd.

### **tls_file_layout.txt**  
Reference layout showing where TLS files must reside in both the PKI workspace and the Elasticsearch runtime directory.

---

## **Purpose of This Module**

This folder provides:

- A reproducible Elasticsearch deployment workflow  
- Clear separation between documentation and templates  
- Strict PKI and TLS practices aligned with real‑world security standards  
- A foundation for integrating Kibana, Fleet, and Logstash securely  

This module is designed for **clarity, onboarding, and portfolio quality**, ensuring anyone can rebuild the Elasticsearch environment from scratch using your PKI and security model.
