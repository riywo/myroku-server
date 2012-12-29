set :rsync_options, '-az --delete --delete-excluded --exclude=.git'
namespace :deploy do
  task :default, :roles => :app do
    finder_options = {:except => { :no_release => true }}
    find_servers(finder_options).each {|s| run_locally(rsync_command_for(s)) }
  end
  after 'deploy:default', 'llenv:bundle'

  def rsync_command_for(server)
    "rsync #{rsync_options} --rsh='ssh -p #{ssh_port(server)}' /home/myroku/myroku-server/ #{rsync_host(server)}:/var/myroku/myroku-server/"
  end

  def ssh_port(server)
    server.port || ssh_options[:port] || 22
  end

  def rsync_host(server)
    respond_to?(:user) ? "#{user}@#{server.host}" : server.host
  end
end

namespace :llenv do
  task :bundle, :roles => :app do
    deploy
    create
    upload "/var/myroku/myroku-server/llenv_bundled", "/var/myroku/bin/llenv"
  end

  task :create, :roles => :app do
    run_locally "rsync -a --delete /home/myroku/myroku-server/ /var/myroku/myroku-server/"
    run_locally "cd /var/myroku/myroku-server/ && bundle exec rake llenv:create"
  end
end
