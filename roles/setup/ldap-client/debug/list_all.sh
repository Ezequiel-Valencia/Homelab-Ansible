ldapsearch -H ldaps://ldap.homelab:636 \
-b "ou=users,dc=ldap,dc=homelab,dc=cool" \
-x -D "cn=ldapservice,ou=users,dc=ldap,dc=homelab,dc=cool" -W \
'(memberOf=cn=linux-user,ou=groups,dc=ldap,dc=homelab,dc=cool)' | less

# The (memberOf) is a filter, and ensures the returned set of users is not random service 
# accounts or app accounts, that should not become linux users. Aka jellyfin-theater should 
# only be an app account, not Linux and it'll be reflected by not being in the 'linux-user'
# group which is currently being filtered on.

