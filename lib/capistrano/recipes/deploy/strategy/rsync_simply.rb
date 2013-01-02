require 'capistrano/recipes/deploy/strategy/remote'

module Capistrano
  module Deploy
    module Strategy
      class RsyncSimply < Remote
        def self.default_attribute(attribute, default_value)
          define_method(attribute) { configuration[attribute] || default_value }
        end

        default_attribute :rsync_options, '-az --delete'
        default_attribute :repository_cache, 'cached-copy'

        def deploy!
          update_remote_cache
          copy_remote_cache
        end

        def update_remote_cache
          finder_options = {:except => { :no_release => true }}
          find_servers(finder_options).each {|s| system(rsync_command_for(s)) }
        end

        def copy_remote_cache
          run("rsync -a --delete #{repository_cache_path}/ #{configuration[:release_path]}/")
        end

        def rsync_command_for(server)
          "rsync #{rsync_options} --rsh='ssh -p #{ssh_port(server)}' #{from_path}/ #{rsync_host(server)}:#{repository_cache_path}/"
        end

        def repository_cache_path
          File.join(shared_path, repository_cache)
        end

        def ssh_port(server)
          server.port || ssh_options[:port] || 22
        end

        def rsync_host(server)
          configuration[:user] ? "#{configuration[:user]}@#{server.host}" : server.host
        end

        def from_path
          "."
        end

        def check!
          super.check do |check|
            check.local.command('rsync')
            check.remote.command('rsync')
          end
        end

      end
    end
  end
end
