#!/bin/bash
rm sssd_homelab.log
sss_cache -E
systemctl restart sssd
