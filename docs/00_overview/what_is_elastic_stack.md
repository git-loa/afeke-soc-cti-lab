
# **What Is the Elastic Stack**

---

## **1. Definition**
The Elastic Stack is a collection of open‑source tools used for:

- collecting data  
- storing data  
- searching and analyzing data  
- visualizing data  
- building security analytics and SIEM workflows  

It is widely used in SOC environments for endpoint telemetry, threat detection, and threat hunting.

---

## **2. Core Components**

### **Elasticsearch**
- Distributed search and analytics engine  
- Stores all logs, events, metrics, and CTI data  
- Provides fast search and aggregation  
- Backbone of the entire stack  

### **Kibana**
- Web interface for interacting with Elasticsearch  
- Dashboards, visualizations, SIEM views, alerts, and management tools  
- Used for detection engineering and threat hunting  

### **Fleet Server**
- Central management layer for Elastic Agents  
- Distributes policies, integrations, and configurations  
- Required for modern Elastic Agent deployments  

### **Elastic Agent**
- Endpoint agent that collects logs, metrics, and security telemetry  
- Replaces Beats (Filebeat, Metricbeat, etc.)  
- Supports integrations like Sysmon‑for‑Linux and Auditd  

### **Logstash**
- Data processing and transformation pipeline  
- Used for CTI ingestion, enrichment, and normalization  
- Optional for basic setups, essential for CTI workflows  

---

## **3. Why SOC Teams Use the Elastic Stack**

### **Centralized Telemetry**
Collects logs from endpoints, servers, network devices, and CTI feeds.

### **Security Analytics**
Provides SIEM capabilities through Elastic Security:

- alerts  
- detection rules  
- timelines  
- case management  

### **Threat Hunting**
Supports fast, flexible queries using KQL and EQL.

### **CTI Integration**
Allows ingestion and enrichment of threat intelligence:

- IOCs  
- IPs  
- domains  
- hashes  
- malware indicators  

### **Scalability**
Handles large volumes of data across distributed nodes.

---

## **4. How the Components Work Together**

1. Elastic Agent collects telemetry from endpoints.  
2. Fleet Server manages the agents and their policies.  
3. Logstash ingests and enriches CTI or custom data.  
4. Elasticsearch stores all events and CTI indicators.  
5. Kibana provides dashboards, SIEM views, and hunting tools.  

This forms a complete SOC pipeline from data collection to detection and analysis.

---

## **5. Elastic Stack in This Lab**

In this learning lab, the Elastic Stack is used to:

- collect Linux endpoint telemetry  
- ingest CTI feeds  
- enrich events with threat intelligence  
- build detection rules  
- perform threat hunting  
- simulate adversary behavior  

The lab uses a single‑VM Elastic Stack deployment with:

- Elasticsearch  
- Kibana  
- Fleet Server  
- Logstash  

Endpoints send telemetry to this VM for analysis.

---

## **6. What You Should Understand Before Moving On**

- Elasticsearch stores and searches data  
- Kibana visualizes and analyzes data  
- Fleet Server manages agents  
- Elastic Agent collects endpoint telemetry  
- Logstash processes and enriches data  

This foundation is required before starting PKI setup and Elastic installation.

---

# **References**

These references provide authoritative definitions and explanations of the Elastic Stack and its components.

1. Elastic. “What is the Elastic Stack.”  
   `https://www.elastic.co/elastic-stack` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Felastic-stack")

2. Elastic. “Elasticsearch: The Heart of the Elastic Stack.”  
   `https://www.elastic.co/elasticsearch` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Felasticsearch")

3. Elastic. “Kibana: Explore, Visualize, and Analyze Data.”  
   [https://www.elastic.co/kibana](https://www.elastic.co/kibana)

4. Elastic. “Fleet and Elastic Agent.”  
   `https://www.elastic.co/guide/en/fleet/current/fleet-overview.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-overview.html")

5. Elastic. “Logstash: Collect, Enrich, and Transform Data.”  
   [https://www.elastic.co/logstash](https://www.elastic.co/logstash)

6. Elastic Security Documentation.  
   `https://www.elastic.co/guide/en/security/current/index.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Fsecurity%2Fcurrent%2Findex.html")
