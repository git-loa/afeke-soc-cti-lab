
# **Afeke SOC + CTI Learning Lab**

A hands‑on **Security Operations Center (SOC)** and **Cyber Threat Intelligence (CTI)** learning environment built with the **Elastic Stack**, **Linux endpoint telemetry**, **CTI enrichment pipelines**, **detection engineering**, and **guided threat‑hunting workflows**.  
This lab is designed as both a **professional portfolio project** and a **structured learning journey**.

---

## 🌐 Overview

This repository documents the architecture, configuration, and workflows of a complete SOC + CTI lab built from scratch.  
It demonstrates how modern security teams:

- Collect and analyze endpoint telemetry  
- Ingest and enrich threat intelligence  
- Build and tune detection rules  
- Perform threat hunting  
- Simulate attacks for research and learning  

Everything is built using **open‑source tools**, **Linux endpoints**, and the **Elastic Security** platform.

---

## 🧭 How to Navigate This Repository

All documentation lives in the `docs/` directory and is organized as a **guided learning path**.  
If you're new to the lab, begin with:

➡️ **`docs/START_HERE.md`**

This file explains the learning journey, prerequisites, and how to follow the documentation step‑by‑step.

---

## 📚 Documentation Structure

The documentation is intentionally structured to be **beginner‑friendly**, **modular**, and **easy to follow**.

```
docs/
│
├── START_HERE.md               # Entry point for beginners
│
├── 00_overview/                # High-level explanations and architecture
│
├── 10_pki/                     # Root CA, Intermediate CA, service certificates
│
├── 20_elasticsearch/           # Elasticsearch installation + TLS
│
├── 30_kibana/                  # Kibana installation + TLS
│
├── 40_fleet_server/            # Fleet Server installation + TLS
│
├── 50_elastic_agent/           # Endpoint agent installation + TLS
│
├── 60_logstash/                # Logstash + CTI ingestion pipelines
│
├── 70_cti/                     # Threat intelligence workflows
│
├── 80_hunting/                 # Threat hunting playbooks and KQL queries
│
└── 99_appendix/                # Troubleshooting, templates, diagrams, glossary
```

Each section builds on the previous one, forming a complete learning path from **PKI → Elastic Stack → Fleet → Endpoint Telemetry → CTI → Detection Engineering → Hunting**.

---

## 🏗️ Lab Architecture

The lab consists of three core components:

### **Elastic Stack VM**
- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash (CTI pipelines)

### **Linux Endpoint 1 (Victim)**
- Elastic Agent  
- Sysmon‑for‑Linux  
- Auditd telemetry

### **Linux Endpoint 2 (Attacker)**
- Attack simulation tools  
- Red‑team frameworks  
- Custom scripts  
- Telemetry forwarded to Elastic for detection engineering and hunting

Architecture diagrams are available in:

```
docs/00_overview/architecture_diagram.md
```

---

## 🔍 Key Features

- **Elastic SIEM Dashboards**  
- **Threat Intelligence Integration**  
- **CTI Enrichment Pipelines**  
- **Detection Engineering**  
- **Threat Hunting Workflows**  
- **Attack Simulation**  
- **Linux Telemetry Collection**  

---

## 🧠 Learning Goals

This lab builds practical skills in:

- SOC analysis  
- Threat intelligence research  
- Log ingestion and normalization  
- CTI enrichment and correlation  
- Detection engineering  
- Threat hunting  
- Linux telemetry  
- Elastic Security operations  

The environment is intentionally structured to support **incremental learning** and **portfolio‑ready documentation**.

---

## 🗺️ Roadmap

### **Phase 1 — Core Environment (In Progress)**
- Elastic Stack VM (Elasticsearch, Kibana, Fleet Server)  
- Logstash with CTI ingestion pipeline  
- Linux Endpoint 1 (Victim) with Elastic Agent + Sysmon‑for‑Linux  
- Documentation structure under `docs/`  
- Initial README and architecture outline  

### **Phase 2 — Attacker VM (Upcoming)**
- Add Linux Endpoint 2 (Attacker)  
- Install attack simulation tools and red‑team frameworks  
- Forward attacker telemetry to Elastic  
- Begin generating adversary behavior for detection testing  

### **Phase 3 — Detection Engineering**
- Create custom detection rules  
- Map rules to MITRE ATT&CK  
- Validate rules using attacker VM activity  
- Document detection logic and tuning steps  

### **Phase 4 — Threat Hunting Workflows**
- Build guided KQL hunting playbooks  
- Create dashboards for host and network visibility  
- Integrate CTI enrichment into hunting workflows  

### **Phase 5 — CTI Expansion**
- Add additional CTI feeds (MISP, MalwareBazaar, Abuse.ch, etc.)  
- Expand enrichment pipelines  
- Build correlation dashboards  

### **Phase 6 — Case Studies & Investigations**
- Add real‑world investigations (hosted in the separate research repo)  
- Link relevant IOCs into the lab for enrichment and detection testing  
- Document end‑to‑end analysis workflows  

---

## 🚀 Future Enhancements

- Additional CTI feeds  
- More detection rules mapped to MITRE ATT&CK  
- Automated attack simulations  
- Dashboard templates  
- Case studies and investigation write‑ups  

---

## 🧪 Related Repository: Threat Intelligence Research Portfolio

This lab focuses on building and operating the SOC + CTI environment.  
All **investigations, case studies, phishing analyses, and CTI research reports** are maintained separately in:

➡️ [https://github.com/git-loa/threat-intel-research-portfolio](https://github.com/git-loa/threat-intel-research-portfolio)

---

## 📄 License

This project is licensed under the MIT License.  
See the `LICENSE` file for details.
