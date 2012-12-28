require 'myroku/config'
require 'myroku/model'

namespace :deploy do
  task :cold do end
  task :migrate do end
  task :migrations do end
end

namespace :llenv do
  desc "Deploy llenv dir"
  task :deploy do
    finder_options = {:except => { :no_release => true }}
    find_servers(finder_options).each {|s| run_locally(llenv_rsync_command_for(s)) }
  end

  def llenv_rsync_command_for(server)
    "rsync #{rsync_options} --rsh='ssh -p #{ssh_port(server)}' /home/myroku/.llenv/ #{rsync_host(server)}:/var/myroku/.llenv/"
  end

  def ssh_port(server)
    server.port || ssh_options[:port] || 22
  end

  def rsync_host(server)
    respond_to?(:user) ? "#{user}@#{server.host}" : server.host
  end
end
after "deploy", "llenv:deploy"
