require 'capistrano/recipes/deploy/strategy/rsync_with_remote_cache'

module Capistrano
  module Deploy
    module Strategy
      class RsyncWithRemoteCacheLlenv < RsyncWithRemoteCache

        def deploy!
          super
          update_remote_llenv
        end

        def update_local_cache
          escape_vendorpath
          super
          restore_vendorpath
          llenv_install
        end

        def check!
          super.check do |check|
            check.local.command("llenv")
          end
        end

        def update_remote_llenv
          finder_options = {:except => { :no_release => true }}
          find_servers(finder_options).each {|s| system(llenv_rsync_command_for(s)) }
        end

        def llenv_rsync_command_for(server)
          "rsync #{rsync_options} --rsh='ssh -p #{ssh_port(server)}' /home/myroku/.llenv/ #{rsync_host(server)}:/home/myroku/.llenv/"
        end

        private

        def escape_vendorpath
          system("cd #{local_cache_path} && mv #{llenv_vendorpath} #{escape_path}")
        end

        def escape_path
          dir = local_cache_path.split('/').last
          File.expand_path("../.cache_#{dir}", local_cache_path)
        end

        def restore_vendorpath
          vendorpath = llenv_vendorpath
          if vendorpath.split('/').size > 1
            parent_dir = File.expand_path("../", vendorpath)
            system("cd #{local_cache_path} && mkdir #{parent_dir}")
          end
          system("cd #{local_cache_path} && mv #{escape_path} #{vendorpath}")
        end

        def llenv_install
          system("cd #{local_cache_path} && llenv install")
        end

        def llenv_vendorpath
          `cd #{local_cache_path} && llenv vendorpath`.chomp
        end

      end
    end
  end
end
