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
    command =  "foreman export daemontools #{local_temp_path}"
    command << " -f #{procfile} -e #{envfile} -a #{application}"
    command << " -d #{app_path} -p #{app.port} -u myroku -t foreman"
    run_locally command
  end

  desc "Deploy exported files"
  task :deploy do
    proc_dirs.each do |dir|
      from = "#{local_temp_path}/#{dir}/"
      to   = "/var/myroku/service/#{dir}"
      finder_options = {:except => { :no_release => true }}
      find_servers(finder_options).each {|s| run_locally(rsync_command_for(s, from, to)) }
      run "#{sudo} ln -fs #{to} /etc/service/"
    end
  end
  before 'foreman:deploy', 'foreman:export'

  end
  before 'foreman:start', 'foreman:deploy'

  def local_temp_path
    path = "/tmp/myroku_daemontools_#{application}"
    Dir.mkdir path unless File.exists? path
    path
  end

  def proc_dirs
    Dir.glob("#{local_temp_path}/*/").map do |dir|
      File.basename dir
    end
  end

  def app
    Myroku::Model::Application.find_by_name(application).app_server
  end

  def app_path
    "/var/myroku/app/#{application}/current"
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

  def rsync_command_for(server, from, to)
    options = '-az --delete'
    "rsync #{options} --exclude='supervise' --rsh='ssh -p #{ssh_port(server)}' #{from} #{rsync_host(server)}:#{to}"
  end

  def ssh_port(server)
    server.port || ssh_options[:port] || 22
  end

  def rsync_host(server)
    respond_to?(:user) ? "#{user}@#{server.host}" : server.host
  end

end
