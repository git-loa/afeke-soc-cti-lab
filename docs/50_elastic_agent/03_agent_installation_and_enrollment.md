# **03 — Elastic Agent Installation and Enrollment (Linux, Production Mode)**

This note documents how to install and enroll the Elastic Agent on a Linux endpoint using the **Kibana‑generated install command** in **on‑premises → Advanced → Production mode**, with TLS validation using the lab’s **CA chain**.

All steps occur **on the endpoint**.

---

## **1. Open the enrollment workflow in Kibana**

In Kibana:

1. Go to **Management → Fleet → Agents**  
2. Select **Add agent**  
3. Choose **Enroll in Fleet** (on‑premises, advanced, production mode)

---

## **2. Select or create an agent policy**

Choose an existing endpoint policy or create a new one, for example:

```
SOC‑CTI – Base Endpoint Policy
```

Do **not** use the Fleet Server policy for normal endpoints.

---

## **3. Confirm Fleet Server and Elasticsearch URLs**

Kibana will display:

```
https://fleet.soc.cti:8220
https://es.soc.cti:9200
```

These must match the **DNS names and SANs** in your certificates.

---

## **4. Confirm CA trust configuration**

Ensure the endpoint has the CA chain at:

```
/etc/elastic-agent/certs/ca-chain.crt
```

This must be the **same CA chain** used by Fleet Server and Elasticsearch.

---

## **5. Review the production‑mode install command**

Kibana generates a command similar to:

```
sudo elastic-agent install \
  --url=https://fleet.soc.cti:8220 \
  --enrollment-token=<TOKEN> \
  --certificate-authorities=/etc/elastic-agent/certs/ca-chain.crt
```

Use the command **exactly as generated**.

---

## **6. Run the install command on the endpoint**

On the endpoint:

```
sudo <paste the full command from Kibana>
```

To follow logs:

```
sudo journalctl -u elastic-agent -f
```

---

## **7. Verify enrollment in Kibana**

In Kibana:

**Management → Fleet → Agents**

Expected:

- Status: **Healthy**  
- Policy: your endpoint policy  
- Last check‑in: recent  

If the agent is Unhealthy or Offline, use your troubleshooting note.

---

# **10. References**

- **Elastic Agent Installation (Linux, Production Mode)**  
  `https://www.elastic.co/guide/en/fleet/current/install-fleet-managed-elastic-agent.html`  
  (Search: elastic.co install fleet‑managed elastic agent)

- **Elastic Agent Enrollment and Policy Assignment**  
  `https://www.elastic.co/guide/en/fleet/current/agent-enrollment.html`  
  (Search: elastic.co Elastic Agent enrollment)

- **Elastic Agent Security and TLS Configuration**  
  `https://www.elastic.co/guide/en/fleet/current/secure-connections.html`  
  (Search: elastic.co Fleet secure connections)

- **Elastic Agent Troubleshooting**  
  `https://www.elastic.co/guide/en/fleet/current/elastic-agent-troubleshooting.html`  
  (Search: elastic.co Elastic Agent troubleshooting)
