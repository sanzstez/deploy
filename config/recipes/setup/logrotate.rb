namespace :logrotate do
  desc "Setup Logrotate configuration"
  task :setup do
    on roles(:all) do
      invoke "logrotate:config"
      invoke "logrotate:restart"
    end
  end

  task :config do
    on roles(:all) do
      template "logrotate.erb", "/etc/logrotate.d/#{fetch(:application)}_application"
    end
  end

  task :restart do
    on roles(:all) do
      sudo "logrotate /etc/logrotate.d/#{fetch(:application)}_application"
    end
  end
end
