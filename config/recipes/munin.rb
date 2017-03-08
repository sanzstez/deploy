namespace :munin do
  desc "Setup all Munin configuration"
  task :setup do
    invoke "munin:config"
    invoke "munin:nginx_basic_auth"
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

  task :nginx_basic_auth do
    on roles(:web) do
      sudo "htpasswd -cb #{fetch(:nginx_path)}/munin_passwd munin #{fetch(:munin_password)}"
    end
  end

end
