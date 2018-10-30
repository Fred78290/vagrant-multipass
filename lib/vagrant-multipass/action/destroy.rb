module VagrantPlugins
  module Multipass
    module Action
      class Destroy

        def initialize(app, _env)
          @app = app
        end

        def call(env)
          destroy_vm env
          env[:machine].id = nil

          @app.call env
        end

        private 
        
        def destroy_vm_by_name(env, config, name)
          _msg = I18n.t("vagrant_multipass.unregistering")
          env[:ui].info "#{_msg} --> #{name}"
          result = Vagrant::Util::Subprocess.execute("multipass", "stop", name)

          if result.exit_code == 0
            _msg = I18n.t("vagrant_multipass.removing")
            env[:ui].info "#{_msg} --> #{name}"
            result = Vagrant::Util::Subprocess.execute("multipass", "delete", name, "-p")
          end
        end

        def destroy_vm(env)
          vm_name = env[:machine].config.vm.hostname
          config = env[:machine].provider_config

          destroy_vm_by_name(env, config, vm_name)
        end
      end
    end
  end
end
