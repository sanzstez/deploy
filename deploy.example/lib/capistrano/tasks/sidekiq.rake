namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      execute :sudo, :systemctl, :reload, :sidekiq, raise_on_non_zero_exit: false
    end
  end

  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, :sidekiq
    end
  end

  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, :sidekiq
    end
  end

  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end

  namespace :monit do
    desc "Monitor sidekiq"
    task :monitor do
      on roles(:app) do
        execute :sudo, "/usr/bin/monit monitor sidekiq", raise_on_non_zero_exit: false
      end
    end

    desc "Unmonitor sidekiq"
    task :unmonitor do
      on roles(:app) do
        execute :sudo, "/usr/bin/monit unmonitor sidekiq", raise_on_non_zero_exit: false
      end
    end
  end
end

namespace :deploy do
  after 'deploy:starting',  'sidekiq:quiet'
  after 'deploy:updated',   'sidekiq:stop'
  after 'deploy:published', 'sidekiq:start'
  after 'deploy:failed', 'sidekiq:restart'
  after 'deploy:check',     'sidekiq:monit:unmonitor'
  after 'deploy:published', 'sidekiq:monit:monitor'
end
