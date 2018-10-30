module VagrantPlugins
  module Multipass
    module Action
      class PowerOff

        def initialize(app, env)
          @app = app
        end

        def call(env)

          vm_name = env[:machine].config.vm.hostname
          config = env[:machine].provider_config

          env[:ui].info I18n.t("vagrant_multipass.powering_off")

          result = Vagrant::Util::Subprocess.execute("multipass", "stop", vm_name)

          fail Errors::VmNotExistsError, name:vm_name, stderr:result.stderr unless result.exit_code == 0

          @app.call env
        end
      end
    end
  end
end
