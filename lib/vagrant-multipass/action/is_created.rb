module VagrantPlugins
  module Multipass
    module Action
      class IsCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)

          vm_name = env[:machine].config.vm.hostname

          result = Vagrant::Util::Subprocess.execute("multipass", "info", vm_name)

          env[:result] = result.exit_code == 0

          @app.call env
        end
      end
    end
  end
end
