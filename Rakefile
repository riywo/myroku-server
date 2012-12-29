$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require

desc "Create bundled llenv"
task "llenv:create" do
  template = ERB.new <<-EOF
#!/bin/bash
unset `env | cut -f1 -d'=' | grep -v 'PORT' | grep -v 'LLENV_ROOT' | xargs`
<% ENV.each { |k,v| %>
export <%= k %>="<%= v %>"<% } %>

args=`eval $@`
exec llenv $args
  EOF
  File.write "llenv_bundled", template.result(binding)
  system "chmod +x llenv_bundled"
end

require 'resque/tasks'
require 'myroku/worker'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
