require 'bundler/capistrano'
load 'deploy/assets'

role :web, "node1509.speedyrails.net" # Your HTTP server, Apache/etc
role :app, "node1509.speedyrails.net" # This may be the same as your `Web` server
role :db,  "node1509.speedyrails.net", :primary => true # This is where Rails migrations will run

set :application, "sockchat"

set :repository,  "https://github.com/speedyrails/websocket-chat.git"

set(:deploy_to) { "/var/www/apps/#{application}" }

set :user, "deploy"

set :deploy_via, :remote_cache
set :scm, "git"
set :keep_releases, 5

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd #{current_path}; bundle exec thin start -C config/thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd #{current_path}; bundle exec thin stop -C config/thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run "thin restart -C /etc/thin/#{application}.yml"
  end

  desc "Tasks to execute after code update"
  task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "if [ -d #{release_path}/tmp ]; then rm -rf #{release_path}/tmp; fi; ln -nfs #{deploy_to}/#{shared_dir}/tmp #{release_path}/tmp"
  end
end
