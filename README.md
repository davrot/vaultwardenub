# What we need

* server with Ubuntu
* DNS entry 
* SSL certificates via https://onlinetools.zfn.uni-bremen.de/server/content/onlinetools/


# Install notes

```
apt update
apt upgrade

apt install git pkg-config libssl-dev curl mc argon2 ca-certificates net-tools

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

sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
ufw reload
iptables -t nat -A POSTROUTING ! -o docker0 -s 172.18.0.0/16 -j MASQUERADE

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

# Mail
# Add root to the /etc/alias file and add the msmtprc file to /etc
apt -y install msmtp msmtp-mta mailutils
vi /etc/msmtprc
chmod 644 /etc/msmtprc
touch /var/log/msmtp.log
chmod 666 /var/log/msmtp.log
# ln -s /usr/bin/msmtp /usr/sbin/sendmail

# echo "Test message" | mail -s "Test subject" root
```

Don't forget to set up the cron job for the backup:

```
crontab -e

0 0 * * * /bin/bash /root/backup/make_backup.sh
*/5 * * * * /bin/bash /root/check_docker.sh
```

# Check the ports with an external computer

```
nmap -v -A vaultwarden.neuro.uni-bremen.de
```

# What now? 

## We need this in /root/mysql:

* .env: Change both passwords
* compose.yml

In /root/mysql

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

## We need this in /root/nginx:

* ca.pem : Public Key plus certificate chain
* key.pem : Private SSL key decrypted  
* nginx.conf

We want this file modes: 

```
-rw------- 1 root root 3268 Jun 28 17:30 key.pem
-rw------- 1 root root 8964 Jun 28 17:30 ca.pem
-rw-r--r-- 1 root root 1327 Jun 28 17:47 nginx.conf
```

## We need this in /root/vaultwarden:

* .env: Change three passwords (mysql passwords need to be the same as above) and the email user name; obviously you want to change the domainname
* add_admin_token.sh : Change password and run ONCE: sh add_admin_token.sh
* compose.yml : Look for neuro.uni-bremen.de related stuff and change it... 

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

# Disable YubiCo and Duo special support

Use the admin console to disable them. We only want to use the FIDO2 Webauth mode. 

# Options to think about:

* Separate SSL Proxy and Vaultwarden / MariaDB
* Allow only 134.102.0.0/16 und 2001:638:708::/48? But then the smartphones need VPN access to the University IP range.
