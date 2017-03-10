#!/bin/bash

# SSH PUBLIC KEY
echo -e '\033[37;44m'"\033[1mPath to your public key: \033[0m"
read -p "Enter: [$HOME/.ssh/id_rsa.pub] " PUBKEY_PATH
PUBKEY_PATH=${PUBKEY_PATH:-$HOME/.ssh/id_rsa.pub}
SSH_PUBLIC_KEY=$(cat $PUBKEY_PATH)

echo -e "\n\033[0;32mKey was read from: \033[7m $PUBKEY_PATH \033[0m\n"
echo -e "=========================\n"

# UBUNTU VERSION 
echo -e '\033[37;44m'"\033[1mSelect your Ubuntu version (1 or 2): \033[0m"
echo -e "\033[1;34m1) Ubuntu 14.04 (trusty)\033[0m"
echo -e "\033[1;34m2) Ubuntu 16.04 (xenial)\033[0m"

while [ -z $prompt ];
  do read -p "Your choise: " choice;
  case "$choice" in
    1) eval "UBUNTU_VERSION=trusty"; break;;
    2) eval "UBUNTU_VERSION=xenial"; break;;
   * ) echo "Just enter 1 or 2, please.";;
  esac;
done;

echo -e "\n\033[0;32mUbuntu version: \033[7m $UBUNTU_VERSION \033[0m\n"
echo -e "=========================\n"

# STAGE 
echo -e '\033[37;44m'"\033[1mSelect stage (1 or 2): \033[0m"
echo -e "\033[1;34m1) staging\033[0m"
echo -e "\033[1;34m2) production\033[0m"

while [ -z $prompt ];
  do read -p "Your choise: " choice;
  case "$choice" in
    1) eval "STAGE=staging"; break;;
    2) eval "STAGE=production"; break;;
   * ) echo "Just enter 1 or 2, please.";;
  esac;
done;

echo -e "\n\033[0;32mStage: \033[7m $STAGE \033[0m\n"
echo -e "=========================\n"

# SERVER IP 
echo -e '\033[37;44m'"\033[1mServer IP or hostname: \033[0m"
read -p "Enter: [127.0.0.1] " SERVER
SERVER=${SERVER:-127.0.0.1}

echo -e "\n\033[0;32mServer: \033[7m $SERVER \033[0m\n"
echo -e "=========================\n"

# APPLICATION NAME
echo -e '\033[37;44m'"\033[1mApplication name: \033[0m"
read -p "Enter: [myapp] " APPLICATION_NAME
APPLICATION_NAME=${APPLICATION_NAME:-myapp}

echo -e "\n\033[0;32mApplication name: \033[7m $APPLICATION_NAME \033[0m\n"
echo -e "=========================\n"

# DEPLOY USER
echo -e '\033[37;44m'"\033[1mDeploy user: \033[0m"
read -p "Enter: [deploy] " DEPLOY_USER
DEPLOY_USER=${DEPLOY_USER:-deploy}

echo -e "\n\033[0;32mDeploy user: \033[7m $DEPLOY_USER \033[0m\n"
echo -e "=========================\n"

# REPO URL
echo -e '\033[37;44m'"\033[1mApplication repository (Git): \033[0m"
read -p "Enter: [git@github.com:RailsApps/learn-rails.git] " REPO_URL
REPO_URL=${REPO_URL:-git@github.com:RailsApps/learn-rails.git}

echo -e "\n\033[0;32mApplication repository: \033[7m $REPO_URL \033[0m\n"
echo -e "=========================\n"

# NGINX SERVER NAME
echo -e '\033[37;44m'"\033[1mNginx server name: \033[0m"
read -p "Enter: [$SERVER] " NGINX_SERVER_NAME
NGINX_SERVER_NAME=${NGINX_SERVER_NAME:-$SERVER}

echo -e "\n\033[0;32mNginx server name: \033[7m $NGINX_SERVER_NAME \033[0m\n"
echo -e "=========================\n"

# RUBY VERSION
echo -e '\033[37;44m'"\033[1mRuby version: \033[0m"
read -p "Enter: [ruby-2.3.3] " RUBY_VERSION
RUBY_VERSION=${RUBY_VERSION:-ruby-2.3.3}

echo -e "\n\033[0;32mRuby version: \033[7m $RUBY_VERSION \033[0m\n"
echo -e "=========================\n"

# DATABASE PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo -e '\033[37;44m'"\033[1mDatabase password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " DATABASE_PASSWORD
DATABASE_PASSWORD=${DATABASE_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\033[0;32mDatabase password: \033[7m $DATABASE_PASSWORD \033[0m\n"
echo -e "=========================\n"

# MONIT PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo -e '\033[37;44m'"\033[1mMonit password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " MONIT_PASSWORD
MONIT_PASSWORD=${MONIT_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\033[0;32mMonit password: \033[7m $MONIT_PASSWORD \033[0m\n"
echo -e "=========================\n"

# MONIT PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo -e '\033[37;44m'"\033[1mMunin password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " MUNIN_PASSWORD
MUNIN_PASSWORD=${MUNIN_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\033[0;32mMunin password: \033[7m $MUNIN_PASSWORD \033[0m\n"
echo -e "=========================\n"

cat > $PWD/config/config_variables.rb <<-EOF
set :repo_url, '$REPO_URL'

set :application_name, '$APPLICATION_NAME'
set :deploy_user, '$DEPLOY_USER'
set :nginx_server_name, '$NGINX_SERVER_NAME'
set :ruby_version, '$RUBY_VERSION'
set :pg_password, '$DATABASE_PASSWORD'
set :monit_password, "$MONIT_PASSWORD"
set :munin_password, "$MUNIN_PASSWORD"
set :ubuntu_version, "$UBUNTU_VERSION"
set :ssh_public_key, "$SSH_PUBLIC_KEY"

server '$SERVER', roles: [:web, :app, :db], primary: true
EOF

echo -e "\n\n========================="
echo -e "Stage deploy config was saved in \033[1m config/config_variables.rb"
echo -e "=========================\n"

echo -e '\033[37;44m'"\033[1mExecute current commands (Step by step): \033[0m\n"
echo -e "\033[1;34mcap $STAGE install:adduser_nonpassword user=root\033[0m"
echo -e "\033[1;34mcap $STAGE install:all\033[0m"
echo -e "\033[1;34mcap $STAGE setup\033[0m"
echo -e "\033[1;34mcap $STAGE setup:all\033[0m\n"