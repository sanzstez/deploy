namespace :monit do
  desc "Setup all Monit configuration"
  task :setup do
    on roles(:all) do
      invoke "monit:monitrc"
      invoke "monit:templates"
      invoke "monit:syntax"
      invoke "monit:reload"
      invoke "monit:nginx_basic_auth"
    end
  end

  task :nginx_basic_auth do
    on roles(:all) do
      sudo "htpasswd -cb /etc/nginx/monit_passwd monit #{fetch(:monit_password)}"
    end
  end

  task :templates do
    on roles(:all) do
      invoke "monit:filesystem"
      invoke "monit:sshd"
      invoke "monit:system"
      invoke "monit:nginx"
      invoke "monit:unicorn"
      invoke "monit:postgresql"
      invoke "monit:redis" if fetch(:sidekiq_support)
      invoke "monit:sidekiq" if fetch(:sidekiq_support)
    end
  end

  task :monitrc do
    on roles(:all) do
      template "monit/monitrc.erb", '/etc/monit/monitrc', permissions: "0700"
    end
  end

  %w[cron nginx system filesystem sshd unicorn delayed_job postgresql redis sidekiq].each do |command|
    desc "Push monit configuration for #{command} to server"
    task command do
      on roles(:all) do
        template "monit/#{command}.erb", "/etc/monit/conf.d/#{command}.conf"
      end
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:all) do
        sudo "service monit #{command}"
      end
    end
  end
end
