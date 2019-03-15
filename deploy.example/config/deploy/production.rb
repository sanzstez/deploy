set :stage, :production
set :rails_env, :production

set :user, "deploy"
set :application, "learn"

set :branch, ENV['BRANCH'] || 'master'
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application)}"

set :unicorn_config_path, "#{shared_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

role :app, %w{deploy@95.85.62.110}
role :web, %w{deploy@95.85.62.110}
role :db,  %w{deploy@95.85.62.110}
