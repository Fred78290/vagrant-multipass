module VagrantPlugins
  module Multipass
    module Action
      class PowerOn

        def initialize(app, env)
          @app = app
        end

        def call(env)
          vm_name = env[:machine].config.vm.hostname
          config = env[:machine].provider_config

          env[:ui].info I18n.t("vagrant_multipass.powering_on")

          result = Vagrant::Util::Subprocess.execute("multipass", "start", vm_name)

          fail Errors::VmNotExistsError, name:vm_name, stderr:result.stderr unless result.exit_code == 0

          # wait for SSH to be available 
          env[:ui].info(I18n.t("vagrant_multipass.waiting_for_ssh"))

          while true
            break if env[:interrupted]                       
            break if env[:machine].communicate.ready?
            sleep 5
          end

          @app.call env
        end
      end
    end
  end
end
