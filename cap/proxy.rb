namespace :deploy do
  task :default do
    update
    reload
  end

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

    conf = template.result(binding)
    put conf, "/tmp/myroku_nginx.conf"
    run "#{sudo} mv /tmp/myroku_nginx.conf /etc/nginx/sites-available/myroku"
  end

  desc "Reload proxy"
  task :reload, :roles => :proxy do
    run "#{sudo} /etc/init.d/nginx restart"
  end
end

