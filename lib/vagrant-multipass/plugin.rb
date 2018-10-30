require "vagrant"

module VagrantPlugins
  module Multipass
    class Plugin < Vagrant.plugin("2")
      name "vagrant-multipass"
      description "Allows Vagrant to manage machines with Canonical Multipass"

      config(:multipass, :provider) do
        require_relative "config"
        Config
      end

      provider(:multipass) do
        # TODO: add logging
        setup_i18n

        # Return the provider
        require_relative "provider"
        Provider
      end

      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", Multipass.source_root)
        I18n.reload!
      end
    end
  end
end
