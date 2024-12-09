!/bin/bash


MAC_ADDRESS=$(connmanctl services | cut -f2 -d_)
IP_ADDRESS=10.0.0.9
GATEWAY=10.0.0.1
MAIN_DNS=10.0.0.6


connmanctl config ethernet_${MAC_ADDRESS}_cable --ipv4 manual ${IP_ADDRESS} 255.255.255.0 ${GATEWAY} --nameservers ${MAIN_DNS} 9.9.9.9