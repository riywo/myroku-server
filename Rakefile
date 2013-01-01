$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require

desc "Create bundled llenv"
task "llenv:create" do
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

unshift @ARGV, 'llenv';
exec(@ARGV);
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
