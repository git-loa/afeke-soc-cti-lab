
# **Fleet Server Module**

This module documents the installation, TLS preparation, configuration, and validation of **Fleet Server** in the SOC/CTI lab environment.  
Fleet Server is deployed on the **same VM** as Elasticsearch and Kibana and is installed using the **Advanced + Production mode** workflow from the Elastic on‑premises guide.

The goal of this module is to provide a clear, reproducible, and secure workflow for enabling Fleet‑managed Elastic Agents in the lab.

---

## **Module Structure**

| File | Description |
|------|-------------|
| **01_installation.md** | Prepares the system for Fleet Server installation using the Kibana UI (Advanced + Production mode). No manual agent installation. |
| **02_applying_tls_certificates.md** | Copies Fleet Server certificates, applies secure permissions, and validates the certificate chain. |
| **03_fleet_server_tls_configuration.md** | Documents the Advanced + Production mode workflow in Kibana, including TLS paths and the generated install command. |
| **04_validating_fleet_server_security.md** | Verifies Fleet Server health, TLS correctness, certificate chain, and Elasticsearch connectivity. |

---

## **Deployment Model**

- Fleet Server runs on the **same VM** as Elasticsearch and Kibana  
- Deployment follows the **on‑premises → Advanced → Production mode** workflow  
- TLS is enforced end‑to‑end using the lab’s PKI  
- Fleet Server is installed using the **Kibana‑generated `elastic-agent install` command**  
- Certificates are placed under:

  ```
  /etc/fleet-server/certs/
  ```

- Permissions follow the same model used for Elasticsearch and Kibana:

  ```
  Directory:     750
  Private key:   600
  Certificates:  644
  ```

This keeps the environment consistent, secure, and easy to onboard.

---

## **What This Module Covers**

- Preparing the VM for Fleet Server  
- Applying PKI certificates and verifying the chain  
- Configuring Fleet Server through the **Advanced + Production mode** workflow  
- Running the Kibana‑generated installation command  
- Validating Fleet Server health and troubleshooting common issues  

---

## **What This Module Does *Not* Cover**

- Manual Fleet Server installation  
- Manual Elastic Agent enrollment commands  
- Multi‑node or production‑scale Fleet Server deployments  
- Load balancing or HA Fleet Server architectures  

These topics are intentionally out of scope for this lab.

---

## **Prerequisites**

Before starting this module:

- Elasticsearch is installed, secured with TLS, and reachable  
- Kibana is installed, secured with TLS, and reachable  
- PKI certificates for Fleet Server have been generated  
- DNS or `/etc/hosts` entries resolve:

  - `es.soc.cti`
  - `kibana.soc.cti`
  - `fleet.soc.cti`

---

## **Learning Objectives**

By the end of this module, you will understand:

- How Fleet Server fits into the Elastic stack  
- How to deploy Fleet Server securely using the **Advanced + Production mode** workflow  
- How to apply and validate TLS certificates for Fleet Server  
- How to confirm Fleet Server health and troubleshoot common issues  