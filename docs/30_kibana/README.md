
# **30 — Kibana**

This folder contains all documentation required to install Kibana, apply PKI‑generated TLS certificates, configure secure HTTPS, and validate that Kibana can authenticate to Elasticsearch over a fully encrypted channel.

The goal of this module is to provide a **reproducible, onboarding‑friendly** workflow for deploying a secure Kibana instance within the SOC/CTI lab.

---

## **Folder Structure**

```
30_kibana/
│
│   01_installation.md
│   02_applying_tls_certificates.md
│   03_kibana_tls_configuration.md
│   04_validating_kibana_security.md
```

---

## **File Overview**

### **01_installation.md**  
Instructions for installing Kibana on Ubuntu/Debian, including repository setup, package installation, and service initialization.

### **02_applying_tls_certificates.md**  
Steps for copying PKI‑generated certificates into `/etc/kibana/certs/`, applying strict permissions, and verifying the certificate chain.

### **03_kibana_tls_configuration.md**  
Configuration of HTTPS and Elasticsearch connectivity in `kibana.yml`, including certificate paths, SAN validation, and secure authentication.

### **04_validating_kibana_security.md**  
Validation steps confirming that HTTPS, certificate verification, authentication, and browser access are functioning correctly.

---

## **Purpose of This Module**

This folder provides:

- A reproducible Kibana deployment workflow  
- Clear separation between documentation and configuration steps  
- Strict PKI and TLS practices aligned with real‑world security standards  
- A foundation for integrating Kibana with Elasticsearch securely  

This module is designed for **clarity, onboarding, and portfolio quality**, ensuring anyone can rebuild the Kibana environment from scratch using your PKI and security model.
