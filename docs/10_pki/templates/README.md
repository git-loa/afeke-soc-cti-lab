# PKI Templates

This folder contains templates used to build the PKI for the SOC/CTI lab.

These files are safe to store in the repository because they contain:
- no private keys
- no certificates
- no sensitive data

## How to Use

1. Copy the templates to the VM under /opt/pki/.
2. Customize SAN templates with your hostname and IP.
3. Use the OpenSSL configuration files to generate:
   - Root CA
   - Intermediate CA
   - Service certificates
4. Follow the PKI workflow in docs/10_pki/.

## Files Included

- root-ca-openssl.cnf
- int-ca-openssl.cnf
- service SAN templates
- CA database templates
- directory structure reference
