# **01 — Installing Fleet Server**

This note prepares the system for installing Fleet Server **using the enrollment command generated in the Kibana UI**.  
In this lab, Fleet Server runs on the **same VM** as Elasticsearch and Kibana.

No manual Elastic Agent installation or service management happens here — Kibana provides the full installation command during Fleet setup.

---

## **1. Lab Deployment Model**

- Fleet Server is deployed on the **same VM** as Elasticsearch and Kibana  
- Installation is performed by **copying the command shown in the Kibana Fleet UI**  
- TLS certificates for Fleet Server will be applied in the next note  

This keeps the workflow simple and reproducible.

---

## **2. Production Deployment Note (Optional)**

In production, Fleet Server is often deployed on a **separate VM** for scalability and isolation.  
This lab intentionally uses a single‑VM setup.

---

## **3. Prerequisites**

Before installing Fleet Server through Kibana, ensure:

### **Elasticsearch is reachable**

```
curl -k https://es.soc.cti:9200
```

### **Kibana is reachable**

```
curl -k https://kibana.soc.cti:5601
```

### **Fleet Server certificate directory exists**

```
sudo mkdir -p /etc/fleet-server/certs
```

Certificates are added in the next note.

---

## **4. Fleet Server Installation Happens in the Kibana UI**

Fleet Server is installed by:

1. Opening Kibana  
2. Navigating to **Management → Fleet**  
3. Selecting **Add Fleet Server**  
4. Choosing **Self‑managed Fleet Server**  
5. Entering:
   - Fleet Server host URL  
   - Elasticsearch URL  
   - TLS certificate paths (configured later)  
6. Copying the **generated installation command**  
7. Running it on the VM  

The command shown in Kibana:

- downloads Elastic Agent  
- installs it  
- enrolls it as Fleet Server  
- configures it as a systemd service  

This note only prepares the environment.  
The full configuration workflow is documented in:

- `03_fleet_server_tls_configuration.md`

---

## **5. Learning Notes**

- Fleet Server is installed through the Kibana UI, not manually  
- The installation command handles both Elastic Agent installation and enrollment  
- TLS certificates are required and applied in the next note  
- Running Fleet Server on the same VM is appropriate for a lab environment  

---

# **10. References**

- **Fleet Server Overview**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-server.html")  
  (Search: elastic.co Fleet Server)

- **Fleet Server Deployment Scenarios**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server-deployment.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-server-deployment.html")  
  (Search: elastic.co Fleet Server deployment)

- **Fleet and Elastic Agent Installation Guide**  
  `https://www.elastic.co/guide/en/fleet/current/install-fleet-managed-elastic-agent.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Finstall-fleet-managed-elastic-agent.html")  
  (Search: elastic.co install Elastic Agent)

- **Fleet Server Requirements**  
  `https://www.elastic.co/guide/en/fleet/current/fleet-server-requirements.html` [(elastic.co in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fwww.elastic.co%2Fguide%2Fen%2Ffleet%2Fcurrent%2Ffleet-server-requirements.html")  
  (Search: elastic.co Fleet Server requirements)

