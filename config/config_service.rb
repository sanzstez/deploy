set :rails_env, fetch(:stage)

set :pg_env, fetch(:rails_env)
set :pg_encoding, 'utf8'
set :pg_database, "#{fetch(:application)}_#{fetch(:stage)}"
set :pg_user, fetch(:application)
set :pg_host, 'localhost'

set :user, ENV['user'] || fetch(:deploy_user)
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application)}"

#SERVER
set :user_home_path, "/home/#{fetch(:user)}"
set :app_home_path, fetch(:deploy_to)
set :shared_path, "#{fetch(:app_home_path)}/shared"
set :current_path, "#{fetch(:app_home_path)}/current"

#UNICORN
set :unicorn_name, "unicorn_#{fetch(:application)}"
set :unicorn_conf_path, "#{fetch(:shared_path)}/config/unicorn.rb"
set :unicorn_pid_path, "#{fetch(:shared_path)}/tmp/pids/unicorn.pid"
set :unicorn_sock_path, "#{fetch(:shared_path)}/sockets/unicorn.sock"

#SIDEKIQ
set :sidekiq_pid_path, "#{fetch(:shared_path)}/tmp/pids/sidekiq.pid"

set :linked_files, %w(config/database.yml config/unicorn.rb)
set :linked_dirs, fetch(:linked_dirs, []) + %w(log pids sockets public/uploads public/assets tmp/cache)

set :log_level, :debug
set :port, 22
set :deploy_via, :remote_cache
set :use_sudo, false
set :bundle_binstubs, nil
set :ssh_options, { forward_agent: true, auth_methods: %w(publickey password), user: fetch(:user) }#, proxy: Net::SSH::Proxy::Command.new('ssh  deploy@xx.xx.xx.xx -W %h:%p') }
set :keep_releases, 1
