$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require

desc "Create exported llenv"
task "llenv:create" do
  export_bin('llenv')
end

desc "Create exported bundle"
task "bundle:create" do
  export_bin('bundle')
end

def export_bin(bin)
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

unshift @ARGV, '<%= bin %>';
exec(@ARGV);
  EOF
  File.write ".#{bin}_exported", template.result(binding)
  system "chmod +x .#{bin}_exported"
end

require 'resque/tasks'
require 'myroku/resque'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
