name             "gitolite2"
maintainer       "Ryosuke IWANAGA"
maintainer_email "riywo.jp@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures gitolite"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ git perl }.each do |cb_depend|
  depends cb_depend
end

%w{ redhat centos scientific amazon debian ubuntu }.each do |os|
  supports os
end
