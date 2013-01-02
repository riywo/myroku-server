$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require

desc "Create exported env"
task "env:create" do
  template = ERB.new <<-EOF
#!/usr/bin/env perl
use strict;
use warnings;

for (keys %ENV) {
  next if /^LLENV/;
  delete $ENV{$_};
}
<% ENV.each { |k,v| %>
$ENV{<%= k %>} = '<%= v %>';<% } %>

exec(@ARGV);
  EOF
  File.write ".env_exported", template.result(binding)
end

require 'resque/tasks'
require 'myroku/resque'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
