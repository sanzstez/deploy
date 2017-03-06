namespace :unicorn do
  desc "Setup all Unicorn configuration"
  task :setup do
    on roles(:all) do
      template "unicorn.rb.erb", fetch(:unicorn_conf_path), { user: fetch(:user), group: 'sudo' }
    end
  end

  desc "Setup all Unicorn init.d script"
  task :script do
    on roles(:web) do
      script "unicorn.sh.erb", fetch(:unicorn_script_path)
    end
  end

  desc "Download unicorn config and init.d files"
  task :sync do
    on roles(:all) do
      sync fetch(:unicorn_conf_path), "unicorn", clear: true
      sync "/etc/init.d/#{fetch(:unicorn_name)}", "unicorn"
    end
  end

  %w[start stop restart reload upgrade status force-stop].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        puts "/etc/init.d/#{fetch(:unicorn_name)} #{command}"
        sudo "/etc/init.d/#{fetch(:unicorn_name)} #{command}"
      end
    end
  end
end
