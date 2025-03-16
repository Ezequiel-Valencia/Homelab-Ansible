## What's Automatic

- Creation of applications
- Creation of policies for these applications


## What Needs to be Done Manually

- Creation of the tunnels
- Installation of the tunnels within the K8 cluster
- Services allowed for the tunnel

- Zero Trust Gateway HTTP firewall (Need to enable it in settings beforehand, but not TLS decryption thats not needed)
    - Block files 20MiB in or out
    - Block Insecure Requests (Malware, Phishing, Spam, etc...)
