require 'myroku/config'
require 'myroku/model'

namespace :proxy do
  desc "Update proxy conf"
  task :update, :roles => :proxy do
    apps = Myroku::Model::Application.all
    template = ERB.new <<-EOF
<% apps.each { |app| %>
server {
    listen 80;
    server_name <%= app.fqdn %>;

    location / {
        proxy_pass <%= app.backend_url %>;
    }
}
<% } %>
    EOF

    file = Tempfile.new('nginx.conf')
    file.write(template.result(binding))

    upload file.path, file.path
    run "#{sudo} mv #{file.path} /etc/nginx/sites-available/myroku"

    file.close
    file.unlink
  end
  after "proxy:update", "proxy:restart"

  desc "Restart proxy"
  task :restart, :roles => :proxy do
    run "#{sudo} /etc/init.d/nginx restart"
  end
end
