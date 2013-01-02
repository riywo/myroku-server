set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_simply
set :rsync_options, '-az --delete --delete-excluded'
set :application, 'myroku-server'
set :deploy_to, "/var/myroku/#{application}"

after "deploy", "env:deploy", "llenv:deploy", "foreman:export"

namespace :env do
  task :deploy, :roles => [:admin, :app] do
    upload ".env_exported", "/var/myroku/bin/env"
    run "chmod +x /var/myroku/bin/env"
  end
  before 'env:deploy', 'env:create'

  task :create do
    run_locally "rake env:create"
  end
end

