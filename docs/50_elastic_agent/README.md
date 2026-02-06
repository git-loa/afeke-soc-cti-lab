
# **Elastic Agent Module**

This module documents the installation, TLS preparation, enrollment, and validation of the **Elastic Agent** on a Linux endpoint in the SOC/CTI lab.  
The agent is installed using the **Kibana‑generated Production mode command** and trusts the same **PKI CA chain** used by Elasticsearch, Kibana, and Fleet Server.

The goal of this module is to provide a clear, reproducible, and secure workflow for onboarding Linux endpoints into Fleet.

---

## **Module Structure**

| File | Description |
|------|-------------|
| **01_prerequisites.md** | Conditions that must be met before installing the agent (Fleet Server health, TLS trust, DNS resolution). |
| **02_applying_tls_certificates.md** | Copying the CA chain to the endpoint, applying permissions, and validating TLS trust. |
| **03_agent_installation_and_enrollment.md** | Installing and enrolling the agent using the Kibana‑generated Production mode command. |
| **04_validating_agent_security.md** | Verifying TLS, enrollment, policy assignment, and data ingestion. |

---

## **Deployment Model**

- Linux endpoint  
- Elastic Agent installed in **Production mode**  
- Enrollment performed using the **Kibana‑generated command**  
- TLS enforced end‑to‑end using the lab’s PKI  
- Endpoint trusts the same CA chain as the rest of the stack  
- Fleet Server acts as the enrollment and policy management point  

The endpoint only requires the **CA chain**:

```
/etc/elastic-agent/certs/ca-chain.crt
```

No private keys or host certificates are needed on the endpoint.

---

## **What This Module Covers**

- Preparing the endpoint for secure enrollment  
- Copying and validating the PKI CA chain  
- Installing Elastic Agent using the official on‑premises workflow  
- Enrolling the agent with Fleet Server  
- Validating TLS, policy assignment, and data ingestion  

---

## **What This Module Does *Not* Cover**

- Windows agent installation  
- Manual agent enrollment commands  
- Multi‑agent automation or orchestration  
- Endpoint Security configuration or tuning  
- Host isolation, malware prevention, or advanced EDR features  

These topics are intentionally out of scope for this module.

---

## **Prerequisites**

Before starting this module:

- Fleet Server is healthy and reachable over TLS  
- Elasticsearch and Kibana are reachable over TLS  
- DNS or `/etc/hosts` resolves:
  - `es.soc.cti`
  - `kibana.soc.cti`
  - `fleet.soc.cti`
- The PKI CA chain is available for copying to the endpoint  
- Kibana can generate the **Production mode** install command  

---

## **Learning Objectives**

By the end of this module, you will understand:

- How Elastic Agent enrolls into Fleet  
- How TLS validation works on Linux endpoints  
- How to securely install and manage agents in Production mode  
- How to validate agent health, policy assignment, and data flow  
