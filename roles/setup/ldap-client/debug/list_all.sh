ldapsearch -H ldaps://ldap.homelab:636 -b "dc=homelab,dc=cool" -x -D "uid=binding_user,ou=people,dc=homelab,dc=cool" -W
