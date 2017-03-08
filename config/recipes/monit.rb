namespace :monit do
  desc "Setup all Monit configuration"
  task :setup do
    invoke "monit:monitrc"
    invoke "monit:templates"

    invoke "monit:slack_script" if fetch(:monit_notification_type).to_s == "slack"

    invoke "monit:syntax"
    invoke "monit:reload"
    invoke "monit:nginx_basic_auth"
  end

  task :nginx_basic_auth do
    on roles(:web) do
      sudo "htpasswd -cb #{fetch(:nginx_path)}/monit_passwd monit #{fetch(:monit_password)}"
    end
  end

  task :slack_script do
    on roles(:web) do
      script "slack_notifications.sh", "/etc/monit/slack_notifications.sh"
    end
  end

  task :templates do
    invoke "monit:filesystem"
    invoke "monit:sshd"
    invoke "monit:system"
    invoke "monit:nginx"
    invoke "monit:unicorn"
    invoke "monit:postgresql"
    # invoke "monit:cron"
    # invoke "monit:delayed_job"
  end

  task :monitrc do
    on roles(:web) do
      template "monit/monitrc.erb", fetch(:monitrc_path), permissions: "0700"
    end
  end

  %w[cron nginx system filesystem sshd unicorn delayed_job postgresql].each do |command|
    desc "Push monit configuration for #{command} to server"
    task command do
      on roles(:web) do
        template "monit/#{command}.erb", "#{fetch(:monit_conf_path)}/#{command}.conf"
      end
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:web) do
        sudo "service monit #{command}"
      end
    end
  end
end

def monit_notify
  if fetch(:monit_notification_type).to_s == "slack"
    'exec "/etc/monit/slack_notifications.sh"'
  else
    "alert"
  end
end
