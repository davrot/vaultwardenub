# What we need

* server with Ubuntu
* DNS entry 
* SSL certificates via https://onlinetools.zfn.uni-bremen.de/server/content/onlinetools/


# Install notes
apt update
apt upgrade

apt install git pkg-config libssl-dev curl mc argon2 ca-certificates

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "{" > /etc/docker/daemon.json
echo '  "iptables": false' >> /etc/docker/daemon.json 
echo "}" >> /etc/docker/daemon.json  

systemctl restart docker

ufw allow in on docker0
ufw route allow in on docker0
ufw route allow out on docker0

ufw allow 22
ufw allow 443
ufw enable

ufw status verbose

docker run hello-world

mkdir /root/nginx
mkdir /root/vaultwarden



# What now? 
We need this in /root/nginx:

*ca.pem : Public Key plus certificate chain
*key.pem : Private SSL key decrypted  
*nginx.conf

We want this file modes: 

```
-rw------- 1 root root 3268 Jun 28 17:30 key.pem
-rw------- 1 root root 8964 Jun 28 17:30 ca.pem
-rw-r--r-- 1 root root 1327 Jun 28 17:47 nginx.conf
```

We need this in /root/vaultwarden:

* .env: Change both passwords
* add_admin_token.sh : Change password and run ONCE: sh add_admin_token.sh
* compose.yml

In /root/vaultwarden

Start docker: 
```
docker compose up -d
```

Stop docker: 
```
docker compose down
```

Show logs continously:
```
docker compose logs -f
```
