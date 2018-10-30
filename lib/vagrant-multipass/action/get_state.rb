
require 'json'

module VagrantPlugins
  module Multipass
    module Action
      class GetState

        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:machine_state_id] = get_state(env[:machine].config.vm.hostname, env[:machine])

          @app.call env
        end

        private

        def get_state(vm_name, machine)
          return :not_created  if machine.id.nil?

          result = Vagrant::Util::Subprocess.execute("multipass", "info", vm_name, "--format=json")

          if result.exit_code != 0
            return :not_created
          end

          result = JSON.parse(result.stdout)

          if result["info"][vm_name]["state"] == "RUNNING"
            :running
          else
            :poweroff
          end
        end
      end
    end
  end
end
