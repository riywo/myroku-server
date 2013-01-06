role :admin, servers['admin']
role :app, *servers['app']

set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_with_remote_cache_llenv
set :rsync_options, '-az --delete --delete-excluded'
set :application, 'myroku-server'
set :repository, "file:///home/myroku/myroku-server"
set :local_cache, "/var/myroku/cache/#{application}"
set :deploy_to, "/var/myroku/#{application}"
set :git_enable_submodules, true

after "deploy", "env:deploy", "llenv:deploy", "config:deploy", "cap:deploy", "foreman:export"

namespace :env do
  task :deploy do
    upload ".env", "#{deploy_to}/current/.env"
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

namespace :cap do
  task :deploy do
    run "rm -f #{deploy_to}/current/cap/app/*.rb"
    Dir.glob("cap/app/*.rb").each do |cap|
      upload cap, "#{deploy_to}/current/#{cap}"
    end
  end
end
