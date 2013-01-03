#require 'berkshelf/vagrant'

unless File.exists? "./.ssh/id_rsa"
  system "mkdir -p .ssh"
  system "ssh-keygen -t rsa -f .ssh/id_rsa -N '' -C 'created by vagrant'"
end
ssh_private_key = File.read "./.ssh/id_rsa".chomp
ssh_public_key  = File.read "./.ssh/id_rsa.pub".chomp

Vagrant::Config.run do |config|
  config.vm.host_name = "myroku-server"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :hostonly, "192.168.110.110"
  config.vm.customize ["modifyvm", :id, "--memory", 512]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]
=begin
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "vendor/cookbooks"]
    chef.roles_path = "roles"
    chef.add_role("myroku_admin")
    chef.add_role("myroku_proxy")
    chef.add_role("myroku_app")
    chef.add_role("myroku_db")
    chef.json = {
      :authorization => {
        :sudo => {
          :users => ["vagrant"],
        },
      },
      :mysql => {
        :server_root_password   => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password   => 'replpass'
      },
      :myroku => {
        :ssh => {
          :private_key => ssh_private_key,
          :public_key  => ssh_public_key,
        },
        :servers => {
          :app   => ['localhost'],
          :proxy => ['localhost'],
          :db    => ['localhost'],
        },
      },
    }
  end
=end
end
