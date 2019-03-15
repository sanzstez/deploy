namespace :unicorn do
  desc "Setup all Unicorn configuration"
  task :setup do
    on roles(:all) do
      invoke "unicorn:config"
      invoke "unicorn:service"
      invoke "unicorn:systemd"
    end
  end

  desc "Add unicorn.rb file"
  task :config do
    on roles(:all) do
      template "unicorn.rb.erb", fetch(:unicorn_conf_path), { user: fetch(:user), group: 'sudo' }
    end
  end

  desc "Setup Unicorn service"
  task :service do
    on roles(:all) do
      script "unicorn.service.erb", '/etc/systemd/system/unicorn.service'
    end
  end

  desc "Setup Unicorn Systemd"
  task :systemd do
    on roles(:all) do
      sudo "systemctl enable unicorn"
      sudo "systemctl daemon-reload"
    end
  end
end
