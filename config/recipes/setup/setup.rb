namespace :setup do
  desc "Provisioning files"
  task :all do
    on roles(:all) do
      invoke "requirements:setup"
      invoke "secrets:setup"
      invoke "nginx:setup"
      invoke "unicorn:setup"
      invoke "sidekiq:setup" if fetch(:sidekiq_support)
      invoke "monit:setup"
      invoke "munin:setup"
      invoke "logrotate:setup"
      invoke "nginx:restart"
    end
  end
end
