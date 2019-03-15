namespace :unicorn do
  task :reload do
    invoke "unicorn:start"
    on roles(:app) do
      execute :sudo, :systemctl, :reload, :unicorn, raise_on_non_zero_exit: false
    end
  end

  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, :unicorn
    end
  end

  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, :unicorn
    end
  end

  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :unicorn
    end
  end

  namespace :monit do
    desc "Monitor unicorn"
    task :monitor do
      on roles(:app) do
        execute :sudo, "/usr/bin/monit monitor unicorn", raise_on_non_zero_exit: false
      end
    end

    desc "Unmonitor unicorn"
    task :unmonitor do
      on roles(:app) do
        execute :sudo, "/usr/bin/monit unmonitor unicorn", raise_on_non_zero_exit: false
      end
    end
  end
end

namespace :deploy do
  after 'deploy:check',     'unicorn:monit:unmonitor'
  after 'deploy:published', 'unicorn:monit:monitor'
end
