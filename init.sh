#!/bin/bash

# UBUNTU VERSION 
echo -e '\E[37;44m'"\033[1mSelect your Ubuntu version (1 or 2): \033[0m"
echo -e "\e[1;34m1) Ubuntu 14.04 (trusty)\e[0m"
echo -e "\e[1;34m2) Ubuntu 16.04 (xenial)\e[0m"

while [ -z $prompt ];
  do read -p "Your choise: " choice;
  case "$choice" in
    1) eval "UBUNTU_VERSION=trusty"; break;;
    2) eval "UBUNTU_VERSION=xenial"; break;;
   * ) echo "Just enter 1 or 2, please.";;
  esac;
done;

echo -e "\n\e[0;32mUbuntu version: \e[5;32;47m $UBUNTU_VERSION \e[0m\n"
echo -e "=========================\n"

# STAGE 
echo -e '\E[37;44m'"\033[1mSelect stage (1 or 2): \033[0m"
echo -e "\e[1;34m1) staging\e[0m"
echo -e "\e[1;34m2) production\e[0m"

while [ -z $prompt ];
  do read -p "Your choise: " choice;
  case "$choice" in
    1) eval "STAGE=staging"; break;;
    2) eval "STAGE=production"; break;;
   * ) echo "Just enter 1 or 2, please.";;
  esac;
done;

echo -e "\n\e[0;32mStage: \e[5;32;47m $STAGE \e[0m\n"
echo -e "=========================\n"

# SERVER IP 
echo -e '\E[37;44m'"\033[1mServer IP or hostname: \033[0m"
read -p "Enter: [127.0.0.1] " SERVER
SERVER=${SERVER:-127.0.0.1}

echo -e "\n\e[0;32mServer: \e[5;32;47m $SERVER \e[0m\n"
echo -e "=========================\n"

# APPLICATION NAME
echo -e '\E[37;44m'"\033[1mApplication name: \033[0m"
read -p "Enter: [myapp] " APPLICATION_NAME
APPLICATION_NAME=${APPLICATION_NAME:-myapp}

echo -e "\n\e[0;32mApplication name: \e[5;32;47m $APPLICATION_NAME \e[0m\n"
echo -e "=========================\n"

# DEPLOY USER
echo -e '\E[37;44m'"\033[1mDeploy user: \033[0m"
read -p "Enter: [deploy] " DEPLOY_USER
DEPLOY_USER=${DEPLOY_USER:-deploy}

echo -e "\n\e[0;32mDeploy user: \e[5;32;47m $DEPLOY_USER \e[0m\n"
echo -e "=========================\n"

# REPO URL
echo -e '\E[37;44m'"\033[1mApplication repository (Git): \033[0m"
read -p "Enter: [git@github.com:RailsApps/learn-rails.git] " REPO_URL
REPO_URL=${REPO_URL:-git@github.com:RailsApps/learn-rails.git}

echo -e "\n\e[0;32mApplication repository: \e[5;32;47m $REPO_URL \e[0m\n"
echo -e "=========================\n"

# NGINX SERVER NAME
echo -e '\E[37;44m'"\033[1mNginx server name: \033[0m"
read -p "Enter: [$SERVER] " NGINX_SERVER_NAME
NGINX_SERVER_NAME=${NGINX_SERVER_NAME:-$SERVER}

echo -e "\n\e[0;32mNginx server name: \e[5;32;47m $NGINX_SERVER_NAME \e[0m\n"
echo -e "=========================\n"

# RUBY VERSION
echo -e '\E[37;44m'"\033[1mRuby version: \033[0m"
read -p "Enter: [ruby-2.3.3] " RUBY_VERSION
RUBY_VERSION=${RUBY_VERSION:-ruby-2.3.3}

echo -e "\n\e[0;32mRuby version: \e[5;32;47m $RUBY_VERSION \e[0m\n"
echo -e "=========================\n"

# DATABASE PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo -e '\E[37;44m'"\033[1mDatabase password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " DATABASE_PASSWORD
DATABASE_PASSWORD=${DATABASE_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\e[0;32mDatabase password: \e[5;32;47m $DATABASE_PASSWORD \e[0m\n"
echo -e "=========================\n"

# MONIT PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo -e '\E[37;44m'"\033[1mMonit password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " MONIT_PASSWORD
MONIT_PASSWORD=${MONIT_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\e[0;32mMonit password: \e[5;32;47m $MONIT_PASSWORD \e[0m\n"
echo -e "=========================\n"

# MONIT PASSWORD
RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo -e '\E[37;44m'"\033[1mMunin password: \033[0m"
read -p "Enter: [Random password: $RANDOM_PASSWORD] " MUNIN_PASSWORD
MUNIN_PASSWORD=${MUNIN_PASSWORD:-$RANDOM_PASSWORD}

echo -e "\n\e[0;32mMunin password: \e[5;32;47m $MUNIN_PASSWORD \e[0m\n"
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

server '$SERVER', roles: [:web, :app, :db], port: fetch(:port), user: fetch(:deploy_user), primary: true
EOF

echo -e "\n\n\========================="
echo -e "Stage deploy config was saved in \e[1m config/config_variables.rb"
echo -e "=========================\n"

echo -e '\E[37;44m'"\033[1mExecute current commands (Step by step): \033[0m\n"
echo -e "\e[1;34mcap $STAGE install:adduser_nonpassword user=root\e[0m"
echo -e "\e[1;34mcap $STAGE install:all\e[0m"
echo -e "\e[1;34mcap $STAGE setup\e[0m"
echo -e "\e[1;34mcap $STAGE setup:all\e[0m\n"