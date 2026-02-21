#!/bin/bash

#########
# Notes #
#########
# It's easiest to use cert in postgres itself rather than HAProxy.
# TLS Check
# openssl s_client -connect postgres.database.homelab.ezequielvalencia.com:5432 -starttls postgres
# https://www.postgresql.org/docs/current/ssl-tcp.html
# /docker_data/traefik/
# /docker_data/postgres/certs/

#======================#
#        Vars          #
#======================#

if [[ "$#" -ne 2 ]]; then
  echo "Error: exactly 2 arguments required"
  exit 1
fi

ACME_DIR=$1
LOCATION_OF_CERTS_DIR=$2


ACME_FILE="${ACME_DIR}/acme.json"
LOCK_FILE="${ACME_DIR}/.lock_cert"
today=$(date +%Y-%m-%d)
file_mod_date=$(date -r "$ACME_FILE" +%Y-%m-%d 2>/dev/null)

#########################
# Script
########################

# Get last modification date (YYYY-MM-DD)
lock_mod_date=""
if [[ -f "$LOCK_FILE" ]]; then
  lock_mod_date=$(date -r "$LOCK_FILE" +%Y-%m-%d)
fi


if [[ "$file_mod_date" == "$today" && "$lock_mod_date" != "$today" ]]; then
  echo "Decomposing acme.json into easy cert files."

  jq -r '.cloudflareResolver.Certificates[0].certificate' ${ACME_FILE} | base64 -d > "${LOCATION_OF_CERTS_DIR}/server.crt"
  jq -r '.cloudflareResolver.Certificates[0].key' ${ACME_FILE} | base64 -d > "${LOCATION_OF_CERTS_DIR}/server.key"

  chmod u=rw,g=,o=r "${LOCATION_OF_CERTS_DIR}server.key"
  chmod u=rw,g=,o=r "${LOCATION_OF_CERTS_DIR}server.crt"

  echo "$today" > "$LOCK_FILE"
  echo "Finished: Decomposing acme.json into easy cert files."
else
    echo "Cert has not changed, not updating."
fi
