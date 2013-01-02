set :rsync_options, '-az --delete --delete-excluded --exclude=.git'
set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_with_remote_cache_llenv
set :git_enable_submodules, true
set :rsync_options, '-az --delete --delete-excluded --exclude=.git'
set :application, 'myroku-server'
set :repository, "file:///home/myroku/myroku-server"
set :local_cache, ".rsync_cache/#{application}"
set :deploy_to, "/var/myroku/#{application}"

after "deploy", "bundle:deploy", "foreman:deploy"

namespace :bundle do
  task :deploy, :roles => [:admin, :app] do
    upload "/var/myroku/myroku-server/.bundle_exported", "/var/myroku/bin/bundle"
  end
  before 'bundle:deploy', 'bundle:create'

  task :create do
    run_locally "cd /var/myroku/myroku-server/ && bundle exec rake bundle:create"
  end
end

