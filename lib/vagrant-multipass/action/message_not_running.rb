require "i18n"

module VagrantPlugins
  module Multipass
    module Action
      class MessageNotRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vmware_multipass.vm_not_running")
          @app.call(env)
        end
      end
    end
  end
end
