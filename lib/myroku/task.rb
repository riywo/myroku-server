require 'myroku/config'
require 'myroku/model'
require 'foreman/env'

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
    "rsync -az --delete --rsh='ssh -p #{ssh_port(server)}' /home/myroku/.llenv/ #{rsync_host(server)}:/var/myroku/.llenv/"
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
    command =  "cd /var/myroku/myroku-server/current && llenv exec foreman export daemontools /var/myroku/service"
    command << " -f #{procfile} -e #{envfile} -a #{application}"
    command << " -d #{app_path} -p #{app.port} -u myroku -t #{template}"
    run command, :hosts => app.host
    run "for dir in `#{proc_dirs}`; do #{sudo} ln -sf $dir /etc/service; done"
    run "for dir in `#{proc_dirs}`; do #{sudo} svc -t $dir; done"
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
    file = "/tmp/myroku_#{application}_env"
    myroku_env = {
      'PORT' => app.port,
      'USER' => 'myroku'
    }
    env = local_env
    env['LLENV_ROOT'] = '/var/myroku/.llenv'
    env['LLENV_ENV'] = llenv_env(local_env.merge(app_env).merge(myroku_env))
    entries = []
    env.each do |k, v|
      entries << "#{k}=#{v}"
    end
    put entries.join("\n"), file
    file
  end

  def llenv_env(hash)
    entries = []
    hash.each do |k, v|
      entries << "#{k}=#{v}"
    end
    entries.join(',')
  end

  def local_env
    env = {}
    file = File.join(app_path, ".env")
    Foreman::Env.new(file).entries do |k, v|
      env[k] = v
    end
    env
  end

  def app_env
    Myroku::Model::Application.find_by_name(application).environment
  end

  def procfile
    File.join(app_path, "Procfile")
  end

  def template
    "/var/myroku/myroku-server/current/foreman"
  end
end
