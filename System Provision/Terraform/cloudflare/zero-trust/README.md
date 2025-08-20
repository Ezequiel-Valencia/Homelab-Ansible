## What's Automatic

- Creation of applications
- Creation of policies for these applications


## What Needs to be Done Manually

- Creation of the tunnels in cloudflare
- Deployment of the tunnels within K8 cluster
- Give the tunnel access to service
- Add service to tunnels mapping in cloudflare

- Zero Trust Gateway HTTP firewall (Need to enable it in settings beforehand, but not TLS decryption thats not needed)
    - Block files 20MiB in or out
    - Block Insecure Requests (Malware, Phishing, Spam, etc...)
