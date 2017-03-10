#LOCAL
set :templates_path, "config/templates"
set :scripts_path, "config/templates/scripts"
set :download_path, "files_from_server"

#SERVER
set :user_home_path, "/home/#{fetch(:user)}"
set :app_home_path, fetch(:deploy_to)
set :shared_path, "#{fetch(:app_home_path)}/shared"
set :current_path, "#{fetch(:app_home_path)}/current"

#NGINX
set :nginx_path, "/etc/nginx"

#UNICORN
set :unicorn_conf_path, "#{fetch(:shared_path)}/config/unicorn.rb"
set :unicorn_pid_path, "#{fetch(:shared_path)}/pids/unicorn.pid"
set :unicorn_sock_path, "#{fetch(:shared_path)}/sockets/unicorn.sock"
set :unicorn_script_path, "/etc/init.d/#{fetch(:unicorn_name)}"

#MONIT
set :monitrc_path, "/etc/monit/monitrc"
set :monit_conf_path, "/etc/monit/conf.d"

#MUNIN
set :munin_conf_path, "/etc/munin/munin.conf"

#YML
set :yml_conf_path, "#{fetch(:shared_path)}/config/secrets.yml"