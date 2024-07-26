docker network create vaultwarden-network
docker network ls | grep vaultwarden-network
ufw allow in on br-698a24f9888e
ufw route allow in on br-698a24f9888e
ufw route allow out on br-698a24f9888e
docker network inspect vaultwarden-network
iptables -t nat -A POSTROUTING ! -o br- -s 172.18.0.0/16 -j MASQUERADE
