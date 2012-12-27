#require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.host_name = "myroku-server"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :hostonly, "192.168.110.110"
  config.vm.customize ["modifyvm", :id, "--memory", 512]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "vendor/cookbooks"]
    chef.roles_path = "roles"
    chef.add_role("myroku_admin")
    chef.add_role("myroku_proxy")
    chef.add_role("myroku_app")
    chef.add_role("myroku_db")
    chef.json = {
      :mysql => {
        :server_root_password   => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password   => 'replpass'
      },
      :myroku => {
        :servers => {
          :app   => ['localhost'],
          :proxy => ['localhost'],
          :db    => ['localhost'],
        },
      },
    }
  end
end
