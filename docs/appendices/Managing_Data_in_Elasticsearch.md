
# **Appendix: Managing Data in Elasticsearch Using Dev Tools**

This appendix provides a safe, minimal set of Dev Tools commands for inspecting, cleaning, and resetting data in a Fleet‑managed SOC/CTI lab.  
It is designed for reproducibility, clarity, and confidence when resetting your environment.

---

# **1. Listing All Data Streams**

Data streams are the primary storage mechanism for Fleet‑managed integrations.

```
GET /_data_stream
```

This returns all Fleet‑created data streams, including:

- `logs-system.*`
- `metrics-system.*`
- `logs-endpoint.events.*`
- `logs-osquery.*`
- `logs-elastic_agent.*`
- `logs-fleet_server.*`

---

# **2. Understanding Data Stream Naming**

Data streams follow this structure:

```
<type>-<integration>.<dataset>-<namespace>
```

Examples:

| Data Stream | Meaning |
|-------------|---------|
| `logs-system.auth-default` | System → auth logs |
| `metrics-system.cpu-default` | System → CPU metrics |
| `logs-endpoint.events.process-default` | Elastic Defend → process events |
| `logs-osquery.result-default` | Osquery results |
| `logs-elastic_agent-default` | Elastic Agent logs |
| `logs-fleet_server-default` | Fleet Server logs |

---

# **3. Safe Data Streams to Delete**

These are safe to delete when resetting your lab:

```
DELETE /_data_stream/logs-system.*
DELETE /_data_stream/metrics-system.*
DELETE /_data_stream/logs-endpoint.events.*
DELETE /_data_stream/logs-osquery.*
```

Deleting these does **not** break Fleet or Elastic Agent.  
New data streams will be recreated automatically.

---

# **4. Data Streams You Should Not Delete (Unless You Want a Full Reset)**

These belong to Fleet Server and Elastic Agent:

- `logs-fleet_server-*`
- `metrics-fleet_server-*`
- `logs-elastic_agent-*`
- `metrics-elastic_agent-*`

Deleting them is still safe, but you lose historical logs.  
Fleet Server and agents continue running and will recreate them.

---

# **5. Deleting a Specific Data Stream**

Example: delete only System auth logs:

```
DELETE /_data_stream/logs-system.auth-default
```

Example: delete only Elastic Defend process events:

```
DELETE /_data_stream/logs-endpoint.events.process-default
```

---

# **6. Clean‑Slate Reset Options**

This section explains how to reset your lab **without uninstalling Fleet Server or Elastic Agents**.

## **6.1. Clean Integration Data Only (Recommended for Routine Resets)**

Deletes System, Defend, Osquery, etc.

```
DELETE /_data_stream/logs-system.*
DELETE /_data_stream/metrics-system.*
DELETE /_data_stream/logs-endpoint.events.*
DELETE /_data_stream/logs-osquery.*
```

Fleet Server and Elastic Agent logs remain intact.  
All integrations continue working and recreate their data streams.

---

## **6.2. Clean Everything Except Fleet Server + Agent Logs**

```
DELETE /_data_stream/*-system.*
DELETE /_data_stream/*-endpoint.*
DELETE /_data_stream/*-osquery.*
DELETE /_data_stream/*-elastic_defend.*
```

This wipes all integration data but preserves internal Fleet/Agent telemetry.

---

## **6.3. Full Clean Slate (Wipe All Data Streams)**

```
DELETE /_data_stream/*
```

This deletes **all** data streams, including Fleet Server and Elastic Agent logs.

### What happens next:
- Fleet Server continues running  
- Elastic Agents continue running  
- All required data streams are recreated automatically  
- Integrations immediately begin sending fresh data  

This is the closest thing to a “factory reset” without reinstalling anything.

---

# **7. Do Agents Need to Be Stopped Before Deleting Data?**

### **No.**

Deleting data streams while agents are running is safe.  
Agents will simply recreate the data streams on the next event.

Stopping agents is optional and only needed if you want:

- zero incoming events during cleanup  
- a perfectly clean slate with no race conditions  

But it is **not required**.

---

# **8. Does Deleting a Data Stream Delete Its Indices?**

### **Yes.**

A data stream manages one or more backing indices:

```
.logs-system.auth-default-000001
.logs-system.auth-default-000002
```

When you delete the data stream:

- the data stream is deleted  
- all backing indices are deleted  
- all documents are deleted  

This is a complete wipe of that dataset.

---

# **9. Checking Lifecycle (Retention) for a Data Stream**

```
GET /_lifecycle/logs-system.auth-default
```

---

# **10. Setting Retention for a Data Stream**

Example: keep System auth logs for 14 days:

```
PUT /_lifecycle/logs-system.auth-default
{
  "data_retention": "14d"
}
```

Example: keep Elastic Defend events for 30 days:

```
PUT /_lifecycle/logs-endpoint.events.process-default
{
  "data_retention": "30d"
}
```

---

# **11. Setting a Global Default Retention (Elastic 8.19+)**

Elastic 8.19 does not expose global retention in the Fleet UI.  
You can set it via Dev Tools:

```
PUT /_cluster/settings
{
  "persistent": {
    "data_streams.lifecycle.default.data_retention": "30d"
  }
}
```

This applies to **all** data streams unless overridden.

---

# **12. Summary: Clean Slate Without Reinstalling**

| Action | Safe? | Requires uninstall? | Recreated automatically? |
|--------|-------|----------------------|---------------------------|
| Delete System data streams | ✔ Yes | No | Yes |
| Delete Elastic Defend data streams | ✔ Yes | No | Yes |
| Delete Osquery data streams | ✔ Yes | No | Yes |
| Delete Elastic Agent logs | ✔ Yes | No | Yes |
| Delete Fleet Server logs | ✔ Yes | No | Yes |
| Delete ALL data streams | ✔ Yes | No | Yes |

You can reset your lab **anytime**, safely, without touching Fleet Server or Elastic Agents.
