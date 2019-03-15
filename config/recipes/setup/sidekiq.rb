namespace :sidekiq do
  desc "Setup all Sidekiq configuration"
  task :setup do
    on roles(:all) do
      invoke "sidekiq:service"
      invoke "sidekiq:systemd"
    end
  end

  desc "Setup Sidekiq service"
  task :service do
    on roles(:all) do
      script "sidekiq.service.erb", '/etc/systemd/system/sidekiq.service'
    end
  end

  desc "Setup Sidekiq Systemd"
  task :systemd do
    on roles(:all) do
      sudo "systemctl enable sidekiq"
      sudo "systemctl daemon-reload"
    end
  end
end
