set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_simply
set :rsync_options, '-az --delete --delete-excluded'
set :application, 'myroku-server'
set :deploy_to, "/var/myroku/#{application}"

after "deploy", "bundle:deploy", "foreman:deploy"

namespace :bundle do
  task :deploy, :roles => [:admin, :app] do
    upload ".bundle_exported", "/var/myroku/bin/bundle"
  end
  before 'bundle:deploy', 'bundle:create'

  task :create do
    run_locally "rake bundle:create"
  end
end

