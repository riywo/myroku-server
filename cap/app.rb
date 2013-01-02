role :app, *servers['app']

set :scm, :git
set :use_sudo, false
set :deploy_via, :rsync_with_remote_cache_llenv
set :git_enable_submodules, true
set :rsync_options, '-az --delete --delete-excluded --exclude=.git'
set(:application) { config_name.split(':').last }
set(:repository)  { "git@localhost:#{application}" }
set(:local_cache) { ".rsync_cache/app/#{application}" }
set(:deploy_to)   { "/var/myroku/app/#{application}" }

after "deploy", "llenv:deploy", "foreman:export"
