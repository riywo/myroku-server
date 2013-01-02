role :app, *servers['app']

set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_with_remote_cache_llenv
set :rsync_options, '-az --delete --delete-excluded'
set :application, 'myroku-server'
set :repository, "file:///home/myroku/myroku-server"
set :local_cache, ".rsync_cache/#{application}"
set :deploy_to, "/var/myroku/#{application}"
set :git_enable_submodules, true

after "deploy", "env:deploy", "llenv:deploy", "config:deploy", "foreman:export"

namespace :env do
  task :deploy do
    upload ".env_exported", "/var/myroku/bin/env"
    run "chmod +x /var/myroku/bin/env"
  end
  before 'env:deploy', 'env:create'

  task :create do
    run_locally "rake env:create"
  end
end

namespace :config do
  task :deploy do
    run "rm -f #{deploy_to}/current/config/*.yml"
    Dir.glob("config/*.yml").each do |yml|
      upload yml, "#{deploy_to}/current/#{yml}"
    end
  end
end
