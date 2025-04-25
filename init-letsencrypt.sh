#!/bin/bash

# This script sets up the initial Let's Encrypt certificates
# Modified from https://github.com/wmnnd/nginx-certbot

# Replace with your domain and email
domains=(aircontroller.ch www.aircontroller.ch)
email="aircontroller@gmail.com" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

# Create required directories
mkdir -p ./nginx/ssl
mkdir -p ./certbot/conf
mkdir -p ./certbot/www

# Ask for confirmation before proceeding
echo "### This script will set up Let's Encrypt certificates for ${domains[*]}"
read -p "Continue? (y/N) " decision
if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
  exit
fi

echo "### Creating dummy certificate for ${domains[0]} ..."
path="/etc/letsencrypt/live/${domains[0]}"
mkdir -p ./certbot/conf/live/${domains[0]}

# Generate dummy certificate
openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
  -keyout ./certbot/conf/live/${domains[0]}/privkey.pem \
  -out ./certbot/conf/live/${domains[0]}/fullchain.pem \
  -subj "/CN=localhost"

echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx-proxy

echo "### Deleting dummy certificate for ${domains[0]} ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/${domains[0]} && \
  rm -Rf /etc/letsencrypt/archive/${domains[0]} && \
  rm -Rf /etc/letsencrypt/renewal/${domains[0]}.conf" certbot

echo "### Requesting Let's Encrypt certificate for ${domains[*]} ..."
# Join $domains to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size 4096 \
    --agree-tos \
    --non-interactive \
    --force-renewal" certbot 

echo "### Reloading nginx ..."
docker-compose exec nginx-proxy nginx -s reload