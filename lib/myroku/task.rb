require 'myroku/config'
require 'myroku/model'

namespace :deploy do
  namespace :pending do
    task :default do end
    task :diff do end
  end
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

namespace :foreman do
  desc "Export Procfile"
  task :export do
    command = "foreman export supervisord #{local_supervisor_path}"
    command << " -f #{procfile} -e #{envfile} -a #{application} -l #{logdir}"
    command << " -p #{app.port} -d /var/myroku/app/#{application}/current -u myroku -t foreman"
    run_locally command
  end

  desc "Deploy exported file"
  task :deploy do
    from = "#{local_supervisor_path}/#{application}.conf"
    to   = "/etc/supervisor.d/#{application}.conf"
    upload from, from, :hosts => app.host
    run "#{sudo} mv #{from} #{to}"
    run "mkdir -p #{logdir}"
  end
  before 'foreman:deploy', 'foreman:export'
  after  'foreman:deploy', 'foreman:reload'

  desc "Reload supervisord"
  task :reload do
    run "#{sudo} supervisorctl reread && #{sudo} supervisorctl add #{application}"
  end

  def app
    Myroku::Model::Application.find_by_name(application).app_server
  end

  def local_supervisor_path
    path = "/tmp/myroku_supervisor.d"
    Dir.mkdir path unless File.exists? path
    path
  end

  def envfile
    files = ["foreman/env"]
    files << File.join(local_cache_path, ".env") if File.exists? File.join(local_cache_path, ".env")
    files.join(',')
  end

  def procfile
    File.join(local_cache_path, "Procfile")
  end

  def logdir
    "/var/log/myroku/app/#{application}"
  end

  def local_cache_path
    File.expand_path(local_cache)
  end

end
