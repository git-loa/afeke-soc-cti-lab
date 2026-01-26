
# **Learning Path**

This document outlines the recommended order for completing the SOC + CTI learning lab.  
Each section builds on the previous one.  
Follow this sequence to avoid configuration issues and to understand the architecture as it develops.

---

# 1. Overview  
`docs/00_overview/`

Purpose:  
Understand the big picture before touching any configuration.

You will learn:  
- What the Elastic Stack is  
- Key terminology  
- How the lab is structured  
- How components interact  
- The full learning path  

Move on when:  
You understand the role of Elasticsearch, Kibana, Fleet Server, Elastic Agent, and Logstash.

---

# 2. PKI (Certificates + TLS)  
`docs/10_pki/`

Purpose:  
Build the certificate infrastructure required for secure communication.

You will learn:  
- Root CA creation  
- Intermediate CA creation  
- Service certificate workflow  
- SANs, CSRs, CA chains  
- File locations and permissions  

Move on when:  
You have valid certificates for Elasticsearch, Kibana, Fleet Server, and Elastic Agent enrollment.

---

# 3. Elasticsearch  
`docs/20_elasticsearch/`

Purpose:  
Install and secure the core data store.

You will learn:  
- Installation  
- TLS configuration  
- Node validation  
- Basic cluster checks  

Move on when:  
Elasticsearch is running with HTTPS enabled and trusted by your PKI.

---

# 4. Kibana  
`docs/30_kibana/`

Purpose:  
Install the UI and connect it securely to Elasticsearch.

You will learn:  
- Installation  
- TLS configuration  
- Connecting to Elasticsearch  
- Accessing the UI  

Move on when:  
Kibana loads successfully in a browser over HTTPS.

---

# 5. Fleet Server  
`docs/40_fleet_server/`

Purpose:  
Set up centralized management for Elastic Agents.

You will learn:  
- Installing Elastic Agent in Fleet Server mode  
- Applying Fleet Server certificates  
- Connecting Fleet Server to Elasticsearch  
- Validating Fleet in Kibana  

Move on when:  
Fleet Server is online and visible in Kibana.

---

# 6. Elastic Agent (Endpoints)  
`docs/50_elastic_agent/`

Purpose:  
Deploy endpoint telemetry collection.

You will learn:  
- Installing Elastic Agent on Linux endpoints  
- Enrolling with TLS  
- Adding Sysmon‑for‑Linux and Auditd  
- Validating telemetry  

Move on when:  
Endpoint events appear in Kibana.

---

# 7. Logstash (CTI Pipelines)  
`docs/60_logstash/`

Purpose:  
Build the CTI ingestion and enrichment pipeline.

You will learn:  
- Installing Logstash  
- Creating pipelines  
- Parsing CTI feeds  
- Normalizing and enriching indicators  
- Forwarding CTI data to Elasticsearch  

Move on when:  
CTI indices are populated and searchable.

---

# 8. CTI Workflows  
`docs/70_cti/`

Purpose:  
Use CTI to enhance detection and hunting.

You will learn:  
- Ingesting external CTI feeds  
- Mapping indicators to ECS  
- Enriching endpoint events  
- Building CTI dashboards  

Move on when:  
You can correlate endpoint events with CTI indicators.

---

# 9. Threat Hunting  
`docs/80_hunting/`

Purpose:  
Develop hunting skills using real telemetry and CTI.

You will learn:  
- KQL queries  
- Hunting playbooks  
- Correlation workflows  
- Host and network visibility techniques  

Move on when:  
You can perform structured hunts and document findings.

---

# 10. Appendix  
`docs/99_appendix/`

Purpose:  
Reference material and troubleshooting.

Includes:  
- Troubleshooting  
- Glossary  
- Diagrams  
- OpenSSL templates  

Use this section anytime you encounter issues or need definitions.

---

# Summary

Follow the learning path in this order:

1. Overview  
2. PKI  
3. Elasticsearch  
4. Kibana  
5. Fleet Server  
6. Elastic Agent  
7. Logstash  
8. CTI  
9. Hunting  
10. Appendix  

This sequence ensures a smooth, reproducible build of the SOC + CTI lab.
