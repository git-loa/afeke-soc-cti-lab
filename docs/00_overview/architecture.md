
# **Architecture Description**

This document provides a high‑level description of the SOC + CTI lab architecture and includes a placeholder for diagrams that will be added later.

---

# 1. System Overview

The lab consists of three major layers:

1. Elastic Stack VM  
2. Linux Endpoints  
3. CTI Ingestion and Enrichment Pipeline  

All communication is secured using TLS certificates generated from the lab’s PKI.

---

# 2. Components

## 2.1 Elastic Stack VM
Runs all core Elastic services:

- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

This VM acts as the central data store, management plane, and analysis interface.

---

## 2.2 Linux Endpoint (Victim)
A monitored host running:

- Elastic Agent  
- Sysmon‑for‑Linux  
- Auditd  

Generates telemetry for detection engineering and hunting.

---

## 2.3 Linux Endpoint (Attacker)
A separate host used for:

- adversary simulation  
- offensive tooling  
- generating realistic attack telemetry  

Telemetry is forwarded to Elastic for analysis.

---

# 3. Data Flow

## 3.1 Endpoint Telemetry Flow
1. Sysmon‑for‑Linux and Auditd generate events.  
2. Elastic Agent collects and normalizes the events.  
3. Elastic Agent sends data to Fleet Server.  
4. Fleet Server forwards data to Elasticsearch.  
5. Kibana displays the data for analysis.

---

## 3.2 CTI Ingestion Flow
1. Logstash pulls CTI feeds from external sources.  
2. Logstash parses, normalizes, and enriches the data.  
3. Logstash outputs CTI indicators into Elasticsearch.  
4. CTI indices become available in Kibana for correlation and hunting.

---

## 3.3 Detection and Alerting Flow
1. Elasticsearch stores endpoint and CTI data.  
2. Detection rules evaluate incoming events.  
3. Alerts are generated when rule conditions match.  
4. Analysts investigate alerts using Kibana’s Security interface.

---

# 4. Network Layout (Text Description)

- All components communicate over HTTPS.  
- Elasticsearch listens on a TLS‑secured port.  
- Kibana connects to Elasticsearch using TLS.  
- Fleet Server connects to Elasticsearch using TLS.  
- Elastic Agents connect to Fleet Server using TLS.  
- Logstash connects to Elasticsearch using TLS.  

The PKI section explains how certificates are created and distributed.

---

# 5. Logical Diagram (Text‑Only)

Elastic Stack VM:
- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

Endpoints:
- Victim Endpoint → Elastic Agent → Fleet Server → Elasticsearch  
- Attacker Endpoint → Elastic Agent → Fleet Server → Elasticsearch  

CTI Pipeline:
- External CTI Feeds → Logstash → Elasticsearch  

Analysis:
- Kibana → Dashboards, SIEM, Alerts, Hunting  

---

# 6. Diagram Placeholder

This section is reserved for future diagrams.  
You may add:

- ASCII diagrams  
- PNG diagrams exported from draw.io, Excalidraw, or Lucidchart  
- Architecture flowcharts  
- Network topology diagrams  

Suggested filenames (to be added later):

```
diagrams/
    elastic_stack_overview.png
    endpoint_telemetry_flow.png
    cti_ingestion_pipeline.png
    full_lab_architecture.png
```

This placeholder ensures the documentation remains structured even before diagrams are created.

---

# 7. Purpose of This Architecture

This architecture supports:

- centralized log collection  
- endpoint visibility  
- CTI enrichment  
- detection engineering  
- threat hunting  
- adversary simulation  
- reproducible SOC workflows  

It is intentionally simple but realistic enough to mirror enterprise SOC environments.

---

# 8. References

1. Elastic Stack Architecture Overview  
   `https://www.elastic.co/elastic-stack` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Felastic-stack")

2. Elastic Security Solution Architecture  
   [https://www.elastic.co/security](https://www.elastic.co/security)

3. Fleet and Elastic Agent Architecture  
   `https://www.elastic.co/guide/en/fleet/current/fleet-overview.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-overview.html")

4. Logstash Pipeline Architecture  
   [https://www.elastic.co/logstash](https://www.elastic.co/logstash)
