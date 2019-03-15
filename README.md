This project is set of capistrano recipes, which help to deploy your application to new Ubuntu (16.04, 18.04) based VPS in 20 minutes.
Theese scripts helps you to install all needed software to the server from scratch, then push all configuration files and deploy the project.

Supported hosting providers:
1. Amazon EC2
2. Linode
3. DigitalOcean
4. etc.

For now added receipts to setup next tech:

1. nginx (latest)
2. PostgreSQL 11 with PostGIS
3. nodejs (latest)
4. unicorn (with autostart script after server reboot)
5. sidekiq (with autostart scripts after server reboot)
5. RVM
6. Monit
7. Munin
8. Logrotate for app logs
9. etc.

Setup:
======

1. Generate new rails application with https://github.com/RailsApps/rails_apps_composer and push it in Git-repository or use existed project. 
2. Clone rollset repository into separately folder.
3. Rollset has separate Gemset, so you need to install all gems with: bundle install
4. Copy deploy scripts from deploy.example folder into you Rails project. (You can copy separately folder or integrate deploy script into your app Gemfile)

Provisioning and deploy:
=======

Workflow. Run next commands on your local machine from rollset directory:
```
1. ./init.sh
2. cap <environment> install:create_user user=root
3. cap <environment> install:all
4. cap <environment> setup
5. cap <environment> setup:all
```

Run deploy command on your local machine from Rails application directory:
```
cap <environment> deploy
```

OK. That's all!

==============

You can edit deploy/config/config_path.rb file if you want change config files location on server or local.

Also, in any moment you can change any of the script laying in deploy/config/recipes folder to add your own, enjoy!
