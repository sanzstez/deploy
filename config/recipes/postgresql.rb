namespace :pg do
  # Using https://github.com/capistrano-plugins/capistrano-postgresql instead of this custom stuff
  # One known issue with this - not standart env like "prod" would not work
  # beucase of issue: https://github.com/capistrano-plugins/capistrano-postgresql/issues/28

  desc "Setup all PG configuration"
  # set :pg_templates_path, "deploy/config/templates"


  task :setup do
    on roles(:all) do
      template "postgresql.yml.erb", "#{fetch(:shared_path)}/config/database.yml", { user: fetch(:user), group: 'sudo' }
    end
  end

  task :sync do
    on roles(:all) do
      sync "#{fetch(:shared_path)}/config/database.yml", "pg", clear: true
    end
  end

  task :psql do
    on roles(:all) do
      interact "sudo -u #{fetch(:pg_system_user)} psql #{fetch(:pg_system_db)}"
    end
  end

  task :list do
    on roles(:all) do
      interact "sudo -u #{fetch(:pg_system_user)} psql #{fetch(:pg_system_db)} -l"
    end
  end

  task :drop_db_and_user do
    on roles(:all) do
      sudo "-u #{fetch(:pg_system_user)} dropdb #{fetch(:pg_database)}"
      sudo "-u #{fetch(:pg_system_user)} dropuser #{fetch(:pg_user)}"
    end
  end

end
