# **Afeke SOC + CTI Learning Lab**

A hands‑on **Security Operations Center (SOC)** and **Cyber Threat Intelligence (CTI)** learning environment built with the **Elastic Stack**, **Linux endpoint telemetry**, **CTI enrichment pipelines**, **detection engineering**, and **guided threat‑hunting workflows**.  
This lab is designed as both a **professional portfolio project** and a **structured learning journey**.

---

## 🌐 **Overview**

This repository documents the architecture, configuration, and workflows of a complete SOC + CTI lab built from scratch.  
It demonstrates how modern security teams:

- Collect and analyze endpoint telemetry  
- Ingest and enrich threat intelligence  
- Build and tune detection rules  
- Perform threat hunting  
- Simulate attacks for research and learning  

Everything is built using **open‑source tools**, **Linux endpoints**, and the **Elastic Security** platform.

---

## 🏗️ **Lab Architecture**

The lab consists of three core components:

- **Elastic Stack VM**  
  - Elasticsearch  
  - Kibana  
  - Fleet Server  
  - Logstash (CTI pipelines)

- **Linux Endpoint 1 (Victim)**  
  - Elastic Agent  
  - Sysmon‑for‑Linux  
  - Auditd telemetry

- **Linux Endpoint 2 (Attacker)**  
  - Attack simulation tools  
  - Red‑team frameworks  
  - Custom scripts  
  - *Telemetry from this endpoint will also be forwarded to Elastic for detection engineering and hunting.*

Architecture and data‑flow diagrams are available in:

```
docs/architecture/
```

---

## 🔍 **Key Features**

- **Elastic SIEM Dashboards**  
  Host, network, process, and alert visibility.

- **Threat Intelligence Integration**  
  External CTI feeds ingested via Logstash.

- **CTI Enrichment Pipelines**  
  Indicators mapped to ECS and applied to endpoint events.

- **Detection Engineering**  
  Custom rules built and tested against real attack data.

- **Threat Hunting Workflows**  
  Guided KQL queries and playbooks for proactive analysis.

- **Attack Simulation**  
  Realistic adversary behavior generated from the attacker VM.

---

## 📚 **Documentation**

All detailed guides, walkthroughs, and configurations live in the `docs/` directory:

```
docs/
│
├── architecture/        # Diagrams and high-level design
├── elastic-stack/       # Elasticsearch, Kibana, Fleet, Logstash setup
├── endpoints/           # Linux endpoint configuration
├── cti/                 # Threat intel ingestion, enrichment, rules
├── hunting/             # Queries and hunting playbooks
└── troubleshooting/     # Common issues and fixes
```

Each section is written to be **beginner‑friendly**, **step‑by‑step**, and **reproducible**.

---

## 🧠 **Learning Goals**

This lab is designed to build practical skills in:

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

## 🗺️ **Roadmap**

This lab is being developed in intentional phases to support incremental learning and realistic SOC + CTI workflows.

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

## 🚀 **Future Enhancements**

Planned additions include:

- Additional CTI feeds (MISP, MalwareBazaar, etc.)  
- More detection rules mapped to MITRE ATT&CK  
- Automated attack simulations  
- Dashboard templates  
- Case studies and investigation write‑ups  

---

## 🧪 **Related Repository: Threat Intelligence Research Portfolio**

This lab focuses on building and operating the SOC + CTI environment.  
All **investigations, case studies, phishing analyses, and CTI research reports** are maintained separately in:

➡️ [(https://github.com/git-loa/threat-intel-research-portfolio](https://github.com/git-loa/threat-intel-research-portfolio)  
A dedicated repository for real‑world threat intelligence investigations, including phishing campaigns, infrastructure analysis, timelines, and MITRE ATT&CK mappings.

---

## 📄 **License**

This project is licensed under the MIT License.  
See the `LICENSE` file for details.
