namespace :secrets do
  desc "Setup all Unicorn configuration"
  task :setup do
    on roles(:all) do
      template "secrets.yml.erb", "#{fetch(:shared_path)}/config/secrets.yml", { user: fetch(:user), group: 'sudo' }
    end
  end
end
