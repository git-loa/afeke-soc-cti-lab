
# **01 — Prerequisites for Elastic Agent Installation (Linux Endpoint)**

This note documents the prerequisites required before installing the Elastic Agent on a Linux endpoint in the SOC/CTI lab.  
The agent will be enrolled using the **Kibana‑generated install command** (on‑premises → Advanced → Production mode) and will trust the lab’s **PKI CA chain**.

No installation or configuration happens in this note.  
This step ensures the environment is ready for secure enrollment.

---

## **1. Fleet Server Must Be Healthy**

Before installing any Elastic Agent, Fleet Server must be:

- **Online**
- **Healthy**
- **Connected to Elasticsearch**
- **Running with TLS enabled**

Verify in Kibana:

**Management → Fleet → Fleet Servers**

Expected:

- Status: **Healthy**  
- Host: `fleet.soc.cti`  
- Port: `8220`  
- TLS: **Enabled**

If Fleet Server is not healthy, resolve issues before continuing.

---

## **2. Elasticsearch and Kibana Must Be Reachable Over TLS**

From the endpoint, verify that Elasticsearch and Kibana are reachable using the CA chain.

### **Elasticsearch**
```
curl --cacert /path/to/ca-chain.crt https://es.soc.cti:9200
```

### **Kibana**
```
curl --cacert /path/to/ca-chain.crt https://kibana.soc.cti:5601
```

Expected:

- JSON response  
- No certificate errors  
- No hostname mismatch warnings  

---

## **3. DNS or /etc/hosts Must Resolve Lab Hostnames**

The endpoint must resolve:

```
es.soc.cti
kibana.soc.cti
fleet.soc.cti
```

If DNS is not configured, add entries to `/etc/hosts`:

```
<IP>  es.soc.cti
<IP>  kibana.soc.cti
<IP>  fleet.soc.cti
```

Replace `<IP>` with the VM’s actual address.

---

## **4. PKI CA Chain Must Be Available**

The endpoint must trust the same PKI CA chain used by:

- Elasticsearch  
- Kibana  
- Fleet Server  

You will copy the CA chain to the endpoint in the next note.

Required file:

```
ca-chain.crt   # Root + Intermediate CA
```

This file must be:

- Present on the endpoint  
- Readable by the agent  
- Correctly ordered (Intermediate → Root)  

---

## **5. Kibana Must Be Ready to Generate the Install Command**

In Kibana:

**Management → Fleet → Agents → Add agent → On‑premises → Advanced → Production mode**

Kibana must be able to generate:

- A valid **service token**  
- A valid **agent policy**  
- A valid **install command**  

No manual command construction is required.

---

## **6. Linux Endpoint Requirements**

The Linux endpoint must meet the following:

- Supported distribution (Ubuntu, Debian, RHEL, CentOS, Rocky, Alma, etc.)  
- Outbound HTTPS access to:
  - `https://es.soc.cti:9200`
  - `https://fleet.soc.cti:8220`
- `systemd` available (required for production mode)
- `curl` installed
- Sufficient privileges to run:

```
sudo elastic-agent install
```

---

## **7. Learning Notes**

- Elastic Agent enrollment depends entirely on Fleet Server health  
- TLS validation is strict — SANs must match exactly  
- The endpoint must trust the same CA chain as the rest of the stack  
- The Kibana‑generated command handles installation and enrollment  
- Production mode creates a persistent systemd service  
