namespace :munin do
  desc "Setup all Munin configuration"
  task :setup do
    sudo "rm -f #{fetch(:munin_conf_path)}"

    invoke "munin:config"
  end

  task :config do
    on roles(:web) do |server|
      template "munin.conf.erb", fetch(:munin_conf_path), permissions: "0700"
    end
  end

end
