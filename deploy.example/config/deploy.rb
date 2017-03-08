set :repo_url, 'git@github.com:sanzstez/learn-rails.git'

set :pty,             true
set :format,          :pretty
set :use_sudo,        false
set :ssh_options,     :forward_agent => true

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system public/uploads}

set :keep_releases, 5
set :deploy_via, :remote_cache

namespace :deploy do
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  task :restart do
    invoke 'unicorn:restart'
  end
end


