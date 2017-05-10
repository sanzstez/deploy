namespace :logrotate do
  desc "Setup Logrotate configuration"
  task :setup do
    invoke "logrotate:config"
    invoke "logrotate:restart"
  end

  task :config do
    on roles(:web) do
      template "logrotate.erb", "/etc/logrotate.d/#{fetch(:application_name)}_application"
    end
  end

  task :restart do
    on roles(:web) do
      sudo "logrotate /etc/logrotate.d/#{fetch(:application_name)}_application"
    end
  end

end
