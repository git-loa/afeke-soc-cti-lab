
# **04 — Validating Elasticsearch Security (HTTPS + Authentication)**  

This note verifies that Elasticsearch is correctly secured with TLS and authentication.  
Validation ensures that:

- HTTPS is enabled  
- The certificate chain is trusted  
- Authentication is enforced  
- The `elastic` superuser can log in  
- No insecure endpoints are exposed  

This step confirms that Elasticsearch is ready for Kibana, Fleet, and Logstash.

---

## **1. Validate HTTPS Connectivity (Insecure Mode)**

This test confirms that Elasticsearch is reachable over HTTPS, even if certificate validation is skipped.

```
curl -k -u elastic https://localhost:9200
```

Expected behavior:

- Prompt for the `elastic` password  
- JSON response containing cluster information  
- No HTTP or TLS errors  

Notes:

- `-k` bypasses certificate validation  
- Useful for initial troubleshooting  

---

## **2. Validate HTTPS With Certificate Verification**

Use the CA chain installed earlier:

```
curl --cacert /etc/elasticsearch/certs/ca-chain.crt \
     -u elastic \
     https://localhost:9200
```

Expected behavior:

- No certificate warnings  
- Successful authentication  
- Valid JSON response  

Notes:

- Confirms that the certificate chain is correct  
- Confirms that the hostname/SAN matches the certificate  

---

## **3. Validate That HTTP (Port 9200) Rejects Plaintext**

Elasticsearch must not accept HTTP after TLS is enabled.

Test:

```
curl http://localhost:9200
```

Expected behavior:

- Connection refused  
- Or an error indicating HTTPS is required  

If this returns valid JSON, TLS is not enabled correctly.

---

## **4. Validate Transport Layer Security**

Transport layer runs on port 9300.

Test:

```
openssl s_client -connect localhost:9300 \
  -CAfile /etc/elasticsearch/certs/ca-chain.crt
```

Expected behavior:

- Successful TLS handshake  
- Certificate subject matches `CN=elasticsearch`  
- No verification errors  

Notes:

- Required for node‑to‑node communication  
- Even single‑node clusters must have transport TLS enabled  

---

## **5. Validate Authentication Enforcement**

Test an unauthenticated request:

```
curl -k https://localhost:9200
```

Expected behavior:

- `security_exception`  
- HTTP 401 Unauthorized  

This confirms that:

- Authentication is required  
- Anonymous access is disabled  

---

## **6. Validate the elastic Superuser**

Test a simple authenticated API call:

```
curl -k -u elastic https://localhost:9200/_security/_authenticate
```

Expected output:

- JSON object showing the authenticated user  
- `"username": "elastic"`  
- `"roles": ["superuser"]`  

This confirms that:

- Authentication works  
- The `elastic` user is active  
- The security subsystem is functioning  

---

## **7. Validate Certificate Details**

Check the certificate:

```
openssl x509 -in /etc/elasticsearch/certs/elasticsearch.crt -text -noout
```

Confirm:

- Correct CN and SAN entries  
- Correct issuer (Intermediate CA)  
- Validity dates  
- Key usage and extended key usage  

---

## **8. Learning Notes**

- Elasticsearch must reject HTTP traffic after TLS is enabled  
- Both HTTP and transport layers must be validated  
- Certificate verification ensures the CA chain is correct  
- Authentication tests confirm that security is enforced  
- These checks prevent misconfiguration before integrating Kibana and Fleet  

---

# **10. References**

- **Elastic TLS Configuration Guide**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html`  
  (Search: elastic.co configuring TLS)

- **Elasticsearch Security Basic Setup (HTTPS)**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup-https.html`  
  (Search: elastic.co enable HTTPS)

- **Elasticsearch Security Settings Overview**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html`  
  (Search: elastic.co security settings)

- **Elasticsearch Certificate and Key Requirements**  
  `https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html`  
  (Search: elastic.co certificate requirements)
