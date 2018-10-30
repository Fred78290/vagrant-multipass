require "i18n"

module VagrantPlugins
  module Multipass
    module Action
      class MessageNotCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vmware_multipass.vm_not_created")
          @app.call(env)
        end
      end
    end
  end
end
