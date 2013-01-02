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
    command =  "/var/myroku/bin/env bundle exec foreman export daemontools /var/myroku/service"
    command << " -f #{procfile} -e #{envfile} -a #{application}"
    command << " -d #{app_path} -p #{app.port} -u myroku -t #{template}"
    run command, :hosts => app.host
    run "for dir in `#{proc_dirs}`; do #{sudo} ln -sf $dir /etc/service; done"
  end

  def proc_dirs
    "echo /var/myroku/service/#{application}-*/"
  end

  def app
    Myroku::Model::Application.find_by_name(application).app_server
  end

  def app_path
    "#{deploy_to}/current"
  end

  def envfile
    files = [tmp_envfile]
    files << File.join(app_path, ".env") if File.exists? File.join(app_path, ".env")
    files.join(',')
  end

  def tmp_envfile
    file = "/tmp/myroku_#{application}_env"
    env = <<-EOF
LLENV_ROOT=/var/myroku/.llenv
LLENV_ENV=PORT=#{app.port}
    EOF
    put env, file
    file
  end

  def procfile
    File.join(app_path, "Procfile")
  end

  def template
    "/var/myroku/myroku-server/current/foreman"
  end
end
