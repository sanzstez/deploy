namespace :install do
  desc "Run: cap deploy:setup install=true"
  task :all do
    on roles(:all) do
      invoke "install:secure_root_user"
      invoke "install:dependencies"
      invoke "install:nginx"
      invoke "install:postgresql"
      invoke "install:redis" if fetch(:sidekiq_support)
      invoke "install:nodejs"
      invoke "install:yarn"
      invoke "install:monit"
      invoke "install:munin"
      invoke "install:rvm"
    end
  end

  task :create_user do
    on roles(:all) do
      user = fetch(:deploy_user)

      unless test(:sudo, "grep -c '^#{user}:' /etc/passwd")
        sudo "adduser --disabled-password --gecos '' #{user} --ingroup sudo"
        sudo "echo '#{user}  ALL = (ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers"
        sudo "mkdir -p /home/#{user}/.ssh"
        sudo "chown #{user} /home/#{user}/.ssh"

        set :ssh_public_key, ask('Insert your ssh public key: ', nil) unless fetch(:ssh_public_key)
        sudo "echo '#{fetch(:ssh_public_key)}' >> /home/#{user}/.ssh/authorized_keys"
        sudo "chown #{user} /home/#{user}/.ssh/authorized_keys"

        info "User added! Now start script again with that user."
      else
        info "User already exists."
      end
      exit
    end
  end

  task :secure_root_user do
    on roles(:all) do
      #sudo "passwd root"
      sudo "sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config"
      sudo "service ssh restart"
    end
  end

  task :dependencies do
    on roles(:all) do
      sudo "apt-get update"
      sudo "apt-get -y install build-essential openssl curl git libreadline-dev ca-certificates"
      sudo "apt-get -y install libpq-dev software-properties-common"
      sudo "apt-get -y install wget htop mc pv apache2-utils libmagickwand-dev imagemagick"
    end
  end

  task :nginx do
    on roles(:all) do
      sudo 'wget --quiet -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -'
      sudo "add-apt-repository -s \"deb http://nginx.org/packages/mainline/ubuntu/ #{fetch(:ubuntu_version)} nginx\""
      sudo 'apt-get update'
      sudo 'apt-get -y install nginx'
    end
  end

  task :postgresql do
    on roles(:all) do
      sudo 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -'
      sudo "add-apt-repository \"deb http://apt.postgresql.org/pub/repos/apt/ #{fetch(:ubuntu_version)}-pgdg main\""
      sudo 'apt-get update'
      sudo "apt-get -y install postgresql-11 postgresql-11-postgis-2.4 postgresql-11-postgis-scripts"
    end
  end

  task :nodejs do
    on roles(:all) do
      sudo 'curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -'
      sudo "apt-get -y install nodejs"
    end
  end

  task :yarn do
    on roles(:all) do
      sudo 'curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -'
      sudo "add-apt-repository \"deb https://dl.yarnpkg.com/debian/ stable main\""
      sudo 'apt-get update'
      sudo 'apt-get -y install yarn'
    end
  end

  task :monit do
    on roles(:all) do
      sudo "apt-get -y install monit"
    end
  end

  task :munin do
    on roles(:all) do
      sudo "apt-get -y install munin munin-plugins-extra"
    end
  end

  task :redis do
    on roles(:all) do
      sudo "apt-get -y install redis-server"
    end
  end

  task :rvm do
    on roles(:all) do
      execute "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
      execute "test -d $HOME/.rvmx || curl -L get.rvm.io | bash -s stable"
      execute 'grep -E "source $HOME/.rvm/scripts/rvm" ~/.bash_profile || echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile'
      execute "source ~/.rvm/scripts/rvm && rvm install #{fetch(:ruby_version)} && rvm use #{fetch(:ruby_version)}@global --default && gem install bundler --no-ri --no-rdoc"
    end
  end
end
