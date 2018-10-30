require 'json'

module VagrantPlugins
  module Multipass
    module Action
      class IsRunning
        
        def initialize(app, env)
          @app = app
        end

        def call(env)

          vm_name = env[:machine].config.vm.hostname

          result = Vagrant::Util::Subprocess.execute("multipass", "info", vm_name, "--format=json")

          fail Errors::VmNotExistsError, name:vm_name, stderr:result.stderr unless result.exit_code == 0

          result = JSON.parse(result.stdout)

          env[:result] = result["info"][vm_name]["state"] == "RUNNING"

          @app.call env
        end
      end
    end
  end
end
