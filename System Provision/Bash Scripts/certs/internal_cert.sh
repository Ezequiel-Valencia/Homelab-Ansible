# -x509=self signed, -nodes=no password protect
# read cert with command `openssl x509 -noout -in certificate.pem -text`

read -p "Domain Name: " DOMAIN_NAME

length_of_cert="$((365 * 5))"

openssl req -newkey rsa:4096 -x509 -sha512 -days $length_of_cert\
 -subj "/C=US/ST=CT/L=Homelab/O=Lambda/OU=Homelab/CN=$DOMAIN_NAME/emailAddress=ezq.valencia@pm.me"\
 -nodes -config internal_cert.config -out certificate.pem -keyout privatekey.pem

pushd ../../../
ansible-vault encrypt './System Provision/Bash Scripts/certs/certificate.pem'
ansible-vault encrypt './System Provision/Bash Scripts/certs/privatekey.pem'
popd
