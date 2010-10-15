default_run_options[:pty] = false

require 'bundler/capistrano'

set :application, "nybles"
set :repository,  "git@github.com:xachro/amped.git"
set :scm, :git

set :user, "nybles"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, "production"
set :application, "nybles"
set :deploy_to, "/home/nybles/app"

server "173.203.207.104", :app, :web, :db, :primary => true

namespace :deploy do
  desc "send the restart signal to the nybles unicorn process"
  task :restart, :roles => :app do
    run "kill -HUP `cat /home/nybles/app/shared/pids/unicorn.pid`"
  end
end