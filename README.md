This project is set of capistrano receipts, which help to deploy your application to new VPS in 20 minutes.
This scripts help you to install all needed software to the server from scratch, then push all configuration files and deploy the project. Also, it helps you to debug issues, read logs, use db and rails consoles and many more.

For now added receipts to setup next tech:
nginx, postgresql, unicorn (with autostart after server reboot), rvm, monit, munin
( but you can easally add your own receipts )

Setup:
======

1. First you need to download this repo.
2. Project has separate Gemset, so you need to install all gems with: bundle install
3. Configure deploy:
- set up deploy environments
- create your deploy script from example in config/deploy.rb.example
- then you should update config varibles in deploy.rb file, minimal set: server, application_name, repo_url, nginx_server_name, ruby_version
4. Copy deploy scripts from deploy.example folder into you project. (you can copy separately folder or integrate deploy script into your app Gemfile)

Deploy:
=======

Workflow on new VPS:
```
cap <environment> install:adduser_nonpassword user=root
cap <environment> install:all
cap <environment> setup
cap <environment> setup:all
```

Monit:
=========

If you want setup monit on your server run, first you need configure varibles:
monit_password - for configure Basic Auth and access monit on you domain/monit.
monit_notification_type - for monit motifications (:email, :slack). If you want email notifications you should edit monitrc template file. For slack - slack_notifications.sh.

Then run:
```
cap <environment> monit:setup
```

This command will:

1. Setup monitrc. To do this separatelly use:
    ```
    cap <environment> monit:monitrc
    ```

2. Setup monit configs to monitor: filesystem, sshd, system, nginx, unicorn, postgresql.
To do this separatelly use:
    ```
    cap <environment> monit:templates
    ```

3. If monit_notification_type seted to "slack", will setup slack notifications script.
To do this separatelly use:
    ```
    cap <environment> monit:slack_script
    ```

If monit_notification_type seted to "email", you should

4. Then test monit for correct cofigurations. To do this separatelly use:
    ```
    cap <environment> monit:syntax
    ```

5. And finally reload monit. To do this separatelly use:
    ```
    cap <environment> monit:reload
    ```

Also you can influence monit using one of the commands:
```
cap <environment> monit:[start stop restart syntax reload]
```

Nginx:
=================

To upload nginx global config and nginx project config use:
```
cap <environment> nginx:setup
```

To download nginx configs and be sure that it's fine use:
```
cap <environment> nginx:sync
```

To influence nginx server use one of next commands:
```
cap <environment> nginx:[start stop restart reload force-reload status configtest rotate upgrade]
```

Unicorn:
=================

To upload unicorn config use:
```
cap <environment> unicorn:setup
```

To upload unicorn script into init.d folder use:
```
cap <environment> unicorn:script
```

To download unicorn configs and be sure that it's fine use:
```
cap <environment> unicorn:sync
```

To influence unicorn server use one of next commands:
```
cap <environment> unicorn:[start stop restart reload upgrade status force-stop]
```


Postgresql:
=================

To upload pg config use:
```
cap <environment> pg:setup
```

To download pg configs and be sure that it's fine use:
```
cap <environment> pg:sync
```

To show lisf of current users and DBs use:
```
cap <environment> pg:list
```

To access psql console use:
```
cap <environment> pg:psql
```

To drop current db and delete current user (get that values from config) use:
```
cap <environment> pg:drop_db_and_user
```

Assets precompile:
=================

If you want precompile assets faster, add next gem to your Gemfile and it will fork compilation for each CPU core:
```
gem 'sprockets-derailleur', '0.0.9'
```

If assets precompile took too many time, you can compile them locally and then copy with command:
```
cap <environment> deploy:compile_assets_locally
```

Remote debuging:
=================

To open PG console from local computer use
```
cap <environment> pg:psql
```

To open rails console from local computer use
```
cap <environment> pg:psql
```

To download all logs from your ptoject use:
```
cap <environment> sync:logs
```

To download unicorn configs use:
```
cap <environment> sync:unicorn
```

To download nginx configs use:
```
cap <environment> sync:nginx
```

To download all configs and logs use:
```
cap <environment> sync:all
```

( All downloaded files you can find in deploy/files_from_server folder )


Solving problems:
===================

1.  If you faced with next issue `PG::ConnectionBad: FATAL:  password authentication failed for user "<username>"` execute next steps to resolve this problem:
   * open project directory from console and delete next files: "db/database.yml" and "shared/config/database.yml".
   * connect to postgres, remove database and user using next commands from console:
     ```
     cap production pg:psql

     DROP DATABASE <application_name>_<environment>;

     DROP USER <application_name>;
     ```
   * run next commands for creating database, user, database.yml and deploy project:

    ```
     cap <environment> setup

     cap <environment> deploy
     ```

Customization:
==============

You can edit deploy/config/config_path.rb file if you want change config files location on server or local.

Also, in any moment you can change any of the script laying in deploy/config/recipes folder to add your own, enjoy!
