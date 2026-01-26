
# **START_HERE.md**  
## **Afeke SOC + CTI Learning Lab — Start Here**

---

# **Purpose of This Lab**
- Build a full SOC + CTI environment from scratch  
- Learn Elastic Stack (Elasticsearch, Kibana, Fleet, Logstash)  
- Collect Linux endpoint telemetry  
- Ingest + enrich threat intelligence  
- Practice detection engineering + threat hunting  
- Create a portfolio‑ready project  

---

# **How to Use These Notes**
- Follow the folders **in order**  
- Each section builds on the previous one  
- Notes are written for **beginners**  
- Every step includes explanations + validation  

---

# **What You Will Build**
- Secure Elastic Stack VM  
- Root CA + Intermediate CA  
- TLS for Elasticsearch, Kibana, Fleet Server  
- Fleet‑managed Linux endpoint  
- Logstash CTI ingestion pipeline  
- Foundation for hunting + detections  

---

# **Learning Path (Follow in Order)**

### **1. Overview**
`docs/00_overview/`
- What Elastic Stack is  
- Key terminology  
- Architecture diagrams  
- Full learning path  

---

### **2. PKI (Certificates + TLS)**
`docs/10_pki/`
- Root CA setup  
- Intermediate CA setup  
- Service certificate workflow  
- SANs, CSRs, CA chains  
- File locations + permissions  

> **PKI is mandatory before installing Elastic Stack.**

---

### **3. Elasticsearch**
`docs/20_elasticsearch/`
- Install Elasticsearch  
- Apply TLS certificates  
- Enable HTTPS  
- Validate secure connection  

---

### **4. Kibana**
`docs/30_kibana/`
- Install Kibana  
- Configure TLS  
- Connect securely to Elasticsearch  
- Validate UI access  

---

### **5. Fleet Server**
`docs/40_fleet_server/`
- Install Elastic Agent in Fleet Server mode  
- Apply Fleet Server certificates  
- Connect securely to Elasticsearch  
- Validate Fleet in Kibana  

---

### **6. Elastic Agent (Endpoints)**
`docs/50_elastic_agent/`
- Install Elastic Agent on Linux endpoint  
- Enroll using TLS  
- Validate telemetry  
- Add Sysmon‑for‑Linux + Auditd  

---

### **7. Logstash (CTI Pipelines)**
`docs/60_logstash/`
- Install Logstash  
- Build CTI ingestion pipelines  
- Normalize + enrich intel  
- Forward to Elasticsearch  
- Validate CTI indices  

---

### **8. CTI Workflows**
`docs/70_cti/`
- Ingest external threat intel  
- Enrich endpoint events  
- Build CTI dashboards  
- Map indicators to ECS  

---

### **9. Threat Hunting**
`docs/80_hunting/`
- KQL queries  
- Hunting playbooks  
- Correlation workflows  
- Host + network visibility  

---

### **10. Appendix**
`docs/99_appendix/`
- Troubleshooting  
- Glossary  
- Diagrams  
- OpenSSL templates  

---

# **Tips for Success**
- Don’t skip PKI  
- Validate after every major step  
- Use troubleshooting notes  
- Treat this like a real SOC environment  
- Take your time — this is a learning journey  

---

# **Start Here**
Open:

```
docs/00_overview/what_is_elastic_stack.md
```

And follow the path step‑by‑step.
