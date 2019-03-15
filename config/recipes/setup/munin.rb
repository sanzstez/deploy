namespace :munin do
  desc "Setup all Munin configuration"
  task :setup do
    on roles(:all) do
      invoke "munin:config"
      invoke "munin:restart"
      invoke "munin:nginx_basic_auth"
    end
  end

  task :config do
    on roles(:all) do |server|
      @server = server
      template "munin.conf.erb", "/etc/munin/munin.conf"
    end
  end

  task :restart do
    on roles(:all) do
      sudo "service munin-node restart"
    end
  end

  task :nginx_basic_auth do
    on roles(:all) do
      sudo "htpasswd -cb /etc/nginx/munin_passwd munin #{fetch(:munin_password)}"
    end
  end
end
