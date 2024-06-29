cat add_admin_token.sh 
echo -n VAULTWARDEN_ADMIN_TOKEN= >> .env
echo -n "REACTED" | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4 | sed 's#\$#\$\$#g' >> .env

