
# **05_integrations.md — Endpoint Integrations (Telemetry Activation)**

This section explains how to enable the **core integrations** required for Linux endpoint telemetry in the SOC + CTI learning lab.  
These integrations transform a basic Elastic Agent installation into a **full SOC‑grade telemetry source** capable of supporting:

- SOC analysis  
- Threat hunting  
- CTI enrichment  
- Detection engineering  
- Linux telemetry research  

All integrations are added through **Fleet → Agent Policies**.

---

# **1. Overview**

After installing the Elastic Agent and enrolling it into Fleet, the agent does **not** collect meaningful telemetry until integrations are added to its assigned policy.

For this lab, the Linux endpoint uses the policy:

```
SOC‑CTI – Base Endpoint Policy
```

This policy must include three integrations:

1. **System**  
2. **Elastic Defend (EDR)**  
3. **Osquery Manager**

These provide the foundational telemetry for SOC + CTI workflows.

---

# **2. System Integration**

### **Purpose**
Collects core Linux system logs:

- syslog  
- authentication logs  
- sudo activity  
- service logs  
- basic process information  

This is the baseline for SOC log analysis and Linux telemetry.

### **How to Add**
1. Navigate to **Management → Fleet → Agent policies**  
2. Select **SOC‑CTI – Base Endpoint Policy**  
3. Click **Add integration**  
4. Search for **System**  
5. Add with default settings (Linux is auto‑detected)  
6. Save the policy  

---

# **3. Elastic Defend (Endpoint Security / EDR)**

### **Purpose**
Provides full EDR telemetry and detection capabilities:

- process events  
- file events  
- network events  
- behavioral detections  
- malware prevention  
- MITRE ATT&CK mapping  
- alert generation  

This is the core of SOC analysis, detection engineering, and threat hunting.

### **How to Add**
1. Click **Add integration**  
2. Search for **Elastic Defend**  
3. Add the integration  
4. Select **Endpoint Security** (default policy)  
5. Save the policy  

Elastic Agent will automatically activate EDR on the endpoint.

---

# **4. Osquery Manager**

### **Purpose**
Enables advanced CTI and threat hunting workflows:

- live osquery queries  
- scheduled queries  
- IOC sweeps  
- asset inventory  
- post‑compromise investigation  

Elastic Agent automatically installs and manages osquery internally.  
No manual installation is required.

### **How to Add**
1. Click **Add integration**  
2. Search for **Osquery Manager**  
3. Add the integration  
4. Save the policy  

---

# **5. Expected Policy State**

After completing all steps, the policy should contain:

- **System**  
- **Elastic Defend**  
- **Osquery Manager**  
- **Elastic Agent Monitoring** (auto‑added)

This configuration turns the Linux endpoint into a **full telemetry source** for SOC + CTI learning.

---

# **6. Next Steps**

Continue to:

➡️ `04_validate_telemetry.md`  
Validate that logs, EDR events, and osquery capabilities are flowing into Elastic Security.

---

10. References
System Integration Documentation  
[https://www.elastic.co/guide/en/integrations/current/system.html](https://www.elastic.co/guide/en/integrations/current/system.html)

Elastic Defend (Endpoint Security) Documentation  
[https://www.elastic.co/guide/en/security/current/elastic-defend.html](https://www.elastic.co/guide/en/security/current/elastic-defend.html)

Osquery Manager Documentation  
[https://www.elastic.co/guide/en/osquery-manager/current/osquery-manager-overview.html](https://www.elastic.co/guide/en/osquery-manager/current/osquery-manager-overview.html)

Elastic Agent Integrations Overview  
[https://www.elastic.co/guide/en/fleet/current/fleet-integrations.html](https://www.elastic.co/guide/en/osquery-manager/current/osquery-manager-overview.html)

