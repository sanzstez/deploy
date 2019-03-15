namespace :pg do
  desc "Setup all Postgres configuration"
  task :setup do
    on roles(:all) do
      template "postgresql.yml.erb", "#{fetch(:shared_path)}/config/database.yml", { user: fetch(:deploy_user), group: 'sudo' }
    end
  end
end
