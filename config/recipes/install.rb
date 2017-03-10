namespace :install do
  desc "Run: cap deploy:setup install=true"
  task :all do
    on roles(:all) do
      invoke("install:secure_root_user")
      sudo "apt-get update"
      invoke "install:dependencies"
      invoke "install:nginx"
      invoke "install:postgresql"
      invoke "install:nodejs"
      #invoke "install:bower"
      invoke "install:monit"
      invoke "install:munin"
      invoke "install:rvm"
    end
  end

  task :adduser_nonpassword do
    desc "Run: cap deploy:setup user=root"
    on roles(:all) do
      user = fetch(:deploy_user)
      unless test(:sudo, "grep -c '^#{user}:' /etc/passwd")
        sudo "adduser --disabled-password --gecos '' #{user} --ingroup sudo"
        sudo "echo '#{user}  ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers"
        execute "mkdir /home/#{user}/.ssh"
        set :ssh_public_key, ask('Insert your ssh public key: ', nil) unless fetch(:ssh_public_key)
        #set :ssh_public_key, ask('insert your ssh public key', nil)
        sudo "echo '#{fetch(:ssh_public_key)}' >> /home/#{user}/.ssh/authorized_keys"
        info "User added! Now start script again with that user."
      else
        info "User already exists."
      end
      exit
    end
  end

  task :adduser do
    desc "Add system user with username="
    on roles(:all) do
      user = ENV['username'] || fetch(:user)
      unless test(:sudo, "grep -c '^#{user}:' /etc/passwd")
        sudo "adduser --gecos '' #{user} --ingroup sudo"
        info "User #{user} added!"
      else
        info "User #{user} already exists."
      end
      exit
    end
  end

  task :secure_root_user do
    on roles(:all) do
      sudo "passwd root"
      sudo "sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config"
      sudo "service ssh restart"
    end
  end

  task :dependencies do
    on roles(:all) do
      sudo "apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core libreadline-dev"
      sudo "apt-get -y install zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxslt1-dev automake"
      sudo "apt-get -y install libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev python-software-properties"
      sudo "apt-get -y install libpq-dev libcurl4-openssl-dev libffi-dev software-properties-common python-software-properties"
      sudo "apt-get -y install wget htop mc apache2-utils libmagickwand-dev imagemagick"
    end
  end

  task :nginx do
    on roles(:all) do
      sudo 'wget --quiet -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -'
      sudo 'add-apt-repository -s "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx"'
      sudo 'apt-get update'
      sudo 'apt-get -y install nginx'
    end
  end

  task :postgresql do
    on roles(:all) do
      sudo 'add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"'
      sudo 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -'
      sudo 'apt-get update'
      sudo "apt-get -y install postgresql-9.6 libpq-dev"
    end
  end

  task :nodejs do
    on roles(:all) do
      sudo 'curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -'
      sudo "apt-get -y install nodejs"
    end
  end

  task :bower do
    on roles(:all) do
      sudo "npm install -g bower"
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

  task :rvm do
    on roles(:all) do
      sudo "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
      execute "test -d $HOME/.rvmx || curl -L get.rvm.io | bash -s stable"
      execute 'grep -E "source $HOME/.rvm/scripts/rvm" ~/.bash_profile || echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile'
      execute "source ~/.rvm/scripts/rvm && rvm install #{fetch(:ruby_version)} && rvm use #{fetch(:ruby_version)}@global --default && gem install bundler --no-ri --no-rdoc"
    end
  end


end
