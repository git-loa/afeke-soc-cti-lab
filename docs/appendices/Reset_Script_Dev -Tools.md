
# **Appendix: Reset Script (Dev Tools)**  
**Purpose:**  
Reset all integration‑generated data in Elasticsearch while keeping Fleet Server, Elastic Agents, and all policies fully operational.  
This is the recommended method for wiping your SOC/CTI lab clean without reinstalling anything.

---

# **1. List All Data Streams (Inspection)**

```
GET /_data_stream
```

Use this to see what exists before deletion.

---

# **2. Reset Script: Clean Integration Data Only (Safe, Recommended)**  
This removes all System, Elastic Defend, and Osquery data — the bulk of your lab telemetry.

```
DELETE /_data_stream/logs-system.*
DELETE /_data_stream/metrics-system.*

DELETE /_data_stream/logs-endpoint.events.*
DELETE /_data_stream/logs-endpoint.alerts.*

DELETE /_data_stream/logs-osquery.*
```

**Effect:**  
- All integration data is wiped  
- Fleet Server continues running  
- Elastic Agents continue running  
- New data streams are recreated automatically  
- No reinstall required  

This is the standard “start fresh” reset.

---

# **3. Reset Script: Clean Everything Except Fleet Server + Agent Logs**

```
DELETE /_data_stream/*-system.*
DELETE /_data_stream/*-endpoint.*
DELETE /_data_stream/*-osquery.*
DELETE /_data_stream/*-elastic_defend.*
```

**Effect:**  
- All integration data wiped  
- Fleet Server logs remain  
- Elastic Agent logs remain  
- Control plane untouched  

Use this if you want to preserve internal Fleet/Agent telemetry.

---

# **4. Full Clean Slate (Wipe ALL Data Streams)**  
This is the closest thing to a “factory reset” without uninstalling anything.

```
DELETE /_data_stream/*
```

**Effect:**  
- All data streams deleted  
- All backing indices deleted  
- Fleet Server continues running  
- Elastic Agents continue running  
- All required data streams are recreated automatically  
- Fresh Elasticsearch with zero telemetry  

This is safe — nothing breaks.

---

# **5. Optional: Stop Agents Before Reset (Not Required)**  
Only use this if you want zero incoming events during deletion.

```
sudo systemctl stop elastic-agent
```

After deletion:

```
sudo systemctl start elastic-agent
```

Again: **not required**, but available.

---

# **6. Verify Fresh Data After Reset**

Search for new incoming events:

```
GET logs-system.auth-default/_search?size=5
```

Or:

```
GET logs-endpoint.events.process-default/_search?size=5
```

You should see fresh documents within seconds.

---

# **7. Notes on Safety and Behavior**

- Deleting a data stream **also deletes its backing indices**  
- Fleet Server does **not** store configuration in data streams  
- Elastic Agent does **not** store configuration in data streams  
- Policies and enrollment live in **Fleet**, not Elasticsearch indices  
- All required data streams are recreated automatically  
- No reinstall is ever required for a clean slate  

This is why this reset method is ideal for labs.

---

# **8. Summary Table**

| Reset Level | Command | Fleet Breaks? | Agents Break? | Recreated Automatically? |
|-------------|----------|----------------|----------------|---------------------------|
| Clean integrations only | Delete system/defend/osquery | No | No | Yes |
| Clean everything except Fleet logs | Delete all except fleet/agent | No | No | Yes |
| Full clean slate | `DELETE /_data_stream/*` | No | No | Yes |

