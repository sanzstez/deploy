namespace :nginx do
  desc "Setup all NGINX configuration"
  task :setup do
    on roles(:all) do
      sudo "rm -f #{fetch(:nginx_path)}/sites-enabled/default"
      sudo "rm -f #{fetch(:nginx_path)}/sites-available/default"

      template "nginx.conf.erb", "#{fetch(:nginx_path)}/nginx.conf"
      template "nginx_app.erb", "#{fetch(:nginx_path)}/sites-available/#{fetch(:application_name)}"

      sudo "ln -sf #{fetch(:nginx_path)}/sites-available/#{fetch(:application_name)} #{fetch(:nginx_path)}/sites-enabled/#{fetch(:application_name)}"
    end
  end

  task :sync do
    on roles(:all) do
      sync "#{fetch(:nginx_path)}/nginx.conf", "nginx", clear: true
      sync "#{fetch(:nginx_path)}/sites-available/#{fetch(:application_name)}", "nginx", recursive: true
    end
  end

  %w[start stop restart reload force-reload status configtest rotate upgrade].each do |command|
    desc "#{command} nginx server"
    task command do
      on roles(:app), except: {no_release: true} do
        exec = "/etc/init.d/nginx #{command}"
        puts exec
        sudo exec
      end
    end
  end

end
