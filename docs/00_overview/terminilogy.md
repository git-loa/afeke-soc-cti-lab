
# **Terminology**

This file defines key terms used throughout the SOC + CTI learning lab.  
Understanding these terms will make the rest of the documentation easier to follow.

---

## **Elastic Stack Terms**

### **Elasticsearch**
Search and analytics engine that stores all logs, events, metrics, and CTI data.

### **Kibana**
Web interface for visualizing data stored in Elasticsearch.  
Used for dashboards, SIEM views, alerts, and hunting.

### **Fleet Server**
Central management service for Elastic Agents.  
Distributes policies and integrations.

### **Elastic Agent**
Endpoint agent that collects logs, metrics, and security telemetry.  
Replaces Beats.

### **Logstash**
Data processing pipeline used for CTI ingestion, enrichment, and transformation.

---

## **PKI and TLS Terms**

### **PKI (Public Key Infrastructure)**
System for issuing, managing, and validating certificates.

### **Root CA (Root Certificate Authority)**
Top‑level trust anchor.  
Signs the Intermediate CA certificate.

### **Intermediate CA**
Signs service certificates.  
Used instead of the Root CA for security.

### **CSR (Certificate Signing Request)**
File generated when requesting a certificate.  
Contains public key and identity information.

### **SAN (Subject Alternative Name)**
Defines valid hostnames or IPs for a certificate.  
Required for modern TLS.

### **CA Chain**
Combination of Intermediate CA certificate + Root CA certificate.  
Used by services to validate trust.

### **Private Key**
Secret key used for encryption and identity.  
Must remain confidential.

---

## **SOC and Telemetry Terms**

### **Telemetry**
Data collected from endpoints, such as logs, processes, network activity, and system events.

### **Sysmon‑for‑Linux**
Tool that provides detailed process, file, and network telemetry.

### **Auditd**
Linux auditing framework that logs system calls and security‑relevant events.

### **Endpoint**
A workstation, server, or VM monitored by Elastic Agent.

---

## **CTI (Cyber Threat Intelligence) Terms**

### **IOC (Indicator of Compromise)**
Observable associated with malicious activity.  
Examples: IPs, domains, URLs, file hashes.

### **Feed**
Source of threat intelligence data (e.g., Abuse.ch, MalwareBazaar).

### **Enrichment**
Adding CTI context to endpoint events.  
Example: tagging an event with “malicious IP”.

### **ECS (Elastic Common Schema)**
Standardized field naming used across Elastic.  
Ensures consistent data structure.

---

## **Detection and Hunting Terms**

### **KQL (Kibana Query Language)**
Query language used for searching data in Kibana.

### **EQL (Event Query Language)**
Sequence‑based query language for detecting multi‑step attack patterns.

### **Detection Rule**
Logic that triggers an alert when suspicious activity is observed.

### **Alert**
Notification generated when a detection rule matches an event.

### **Timeline**
Elastic Security feature for investigating events and building cases.

---

## **Architecture Terms**

### **Node**
A single Elasticsearch server instance.

### **Cluster**
Group of Elasticsearch nodes working together.

### **Index**
Logical storage unit in Elasticsearch.  
Similar to a database table.

### **Pipeline**
Processing workflow in Logstash or Elasticsearch Ingest Node.

---

## **References**

1. Elastic. “Elastic Stack Overview.”  
   `https://www.elastic.co/elastic-stack` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Felastic-stack")

2. Elastic. “Elasticsearch Concepts.”  
   `https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Felasticsearch%2Freference%2Fcurrent%2Findex.html")

3. Elastic. “Kibana Concepts.”  
   `https://www.elastic.co/guide/en/kibana/current/index.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Fkibana%2Fcurrent%2Findex.html")

4. Elastic. “Fleet and Elastic Agent.”  
   `https://www.elastic.co/guide/en/fleet/current/fleet-overview.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-overview.html")

5. Elastic. “Logstash Concepts.”  
   `https://www.elastic.co/guide/en/logstash/current/index.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Flogstash%2Fcurrent%2Findex.html")

6. Elastic Common Schema (ECS).  
   `https://www.elastic.co/guide/en/ecs/current/index.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Fecs%2Fcurrent%2Findex.html")
