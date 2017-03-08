namespace :munin do
  desc "Setup all Munin configuration"
  task :setup do
    invoke "munin:config"
  end

  task :config do
    on roles(:web) do |server|
      @server = server
      template "munin.conf.erb", fetch(:munin_conf_path)
    end
  end

  task :restart do
    on roles(:web) do
      sudo "service munin-node restart"
    end
  end

end
