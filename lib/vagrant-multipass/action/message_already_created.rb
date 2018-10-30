require "i18n"

module VagrantPlugins
  module Multipass
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vagrant_multipass.vm_already_created")
          @app.call(env)
        end
      end
    end
  end
end
