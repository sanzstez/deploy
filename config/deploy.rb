lock '3.5.0'

load 'config/config_variables.rb'

set :rails_env, fetch(:stage)
set :pg_env, fetch(:rails_env)
set :pg_encoding, "utf8"
set :pg_database, "#{fetch(:application_name)}_#{fetch(:stage)}"
set :pg_user, fetch(:application_name)
set :pg_host, "localhost"

set :monit_notification_type, :email # or :slack . Configure mailserver in monitrc file or slack in slack_notifications.sh

set :user, ENV['user'] || fetch(:deploy_user)
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application_name)}"
set :branch, "master"
set :unicorn_name, "unicorn_#{fetch(:application_name)}"

set :linked_files, %w{config/database.yml config/unicorn.rb config/secrets.yml}
set :linked_dirs, fetch(:linked_dirs, []) + %w{log pids sockets public/uploads public/assets tmp/cache}

set :db_local_clean, true
set :db_remote_clean, true
set :locals_rails_env, "development"
set :dump_file_folder, "../db"
set :conditionally_migrate, true

set :log_level, :debug
set :port, 22
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :bundle_binstubs, nil
set :ssh_options, { forward_agent: true, auth_methods: %w(publickey password), user: fetch(:user)#, proxy: Net::SSH::Proxy::Command.new('ssh  deploy@xx.xx.xx.xx -W %h:%p') }
set :keep_releases, 5

after 'postgresql:generate_database_yml', 'pg:setup'

task :setup do
  invoke "requirements:make_dirs"
end

namespace :requirements do
  desc 'Create Directories for Unicorn Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/sockets -p"
      execute "mkdir #{shared_path}/pids -p"
    end
  end
end

load 'config/config_path.rb'
Dir.glob('config/recipes/*.rb').each { |r| load r }
