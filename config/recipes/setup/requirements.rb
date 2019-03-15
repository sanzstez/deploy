namespace :requirements do
  desc 'Setup requirements'
  task :setup do
    on roles(:all) do
      invoke "requirements:make_dirs"
    end
  end

  task :make_dirs do
    on roles(:all) do
      execute "mkdir #{fetch(:shared_path)}/sockets -p"
      execute "mkdir #{fetch(:shared_path)}/tmp/pids -p"
    end
  end
end
