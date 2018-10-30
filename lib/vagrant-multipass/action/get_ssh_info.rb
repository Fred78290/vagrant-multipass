
require 'json'

module VagrantPlugins
  module Multipass
    module Action
      class GetSshInfo

        def initialize(app, env)
          @logger = Log4r::Logger.new("vagrant::plugins::multipass::ssh_info")
          @app = app
        end

        def call(env)
          env[:machine_ssh_info] = get_ssh_info(env[:machine].config.vm.hostname, env[:machine])

          @app.call env
        end

        private

        def get_ssh_info(vm_name, machine)
          config = machine.provider_config

          result = Vagrant::Util::Subprocess.execute("multipass", "info", vm_name, "--format=json")

          fail Errors::VmNotExistsError, name:vm_name, stderr:result.stderr unless result.exit_code == 0
          
          result = JSON.parse(result.stdout)

          # Try to drop IPV6 addresses
          ipAddresses = result["info"][vm_name]["ipv4"]

          if ! ipAddresses.empty?
            @logger.debug("ipAddresses: #{ipAddresses}")

            # Debian/ubuntu....
            if config.nic_inversed
              ipAddresse = ipAddresses[ipAddresses.length - 1]
            else
              ipAddresse = ipAddresses[0]
            end

            return {
              :host => ipAddresse,
              :port => 22
            }
          else
            @logger.debug("Doesnt found network card")

            return nil
          end
        end
      end
    end
  end
end
