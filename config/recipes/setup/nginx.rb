namespace :nginx do
  desc "Setup all NGINX configuration"
  task :setup do
    on roles(:all) do
      invoke "nginx:config"
      invoke "nginx:configtest"
    end
  end

  desc "Add NGINX config"
  task :config do
    on roles(:all) do
      sudo "rm -f /etc/nginx/conf.d/default.conf"

      sudo "mkdir /etc/nginx/sites-enabled -p"
      sudo "mkdir /etc/nginx/sites-available -p"

      template "nginx.conf.erb", "/etc/nginx/nginx.conf"
      template "nginx.app.erb", "/etc/nginx/sites-available/#{fetch(:application)}"

      sudo "ln -sf /etc/nginx/sites-available/#{fetch(:application)} /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end

  desc "Config Test NGINX"
  task :configtest do
    on roles(:all) do
      sudo "service nginx configtest"
    end
  end

  desc "Restart NGINX"
  task :restart do
    on roles(:all) do
      sudo "service nginx restart"
    end
  end
end
