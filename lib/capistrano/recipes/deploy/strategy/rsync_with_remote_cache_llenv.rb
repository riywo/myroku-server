require 'capistrano/recipes/deploy/strategy/rsync_with_remote_cache'

module Capistrano
  module Deploy
    module Strategy
      class RsyncWithRemoteCacheLlenv < RsyncWithRemoteCache

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

        private

        def escape_vendorpath
          system("cd #{local_cache_path} && mv #{llenv_vendorpath} #{escape_path}")
        end

        def escape_path
          dir = local_cache_path.split('/').last
          "/tmp/myroku_#{dir}_vendor"
        end

        def restore_vendorpath
          vendorpath = llenv_vendorpath
          if vendorpath.split('/').size > 1
            parent_dir = vendorpath.split('/')
            parent_dir.pop
            parent_dir = File.join parent_dir
            system("cd #{local_cache_path} && mkdir -p #{parent_dir}")
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
