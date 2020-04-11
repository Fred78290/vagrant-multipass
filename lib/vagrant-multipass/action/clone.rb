require "i18n"
require 'tempfile'
require 'yaml'
require 'securerandom'

module VagrantPlugins
  module Multipass
    module Action
      class Clone

        def initialize(app, _env)
          @logger = Log4r::Logger.new("vagrant::plugins::multipass::action::clone")
          @app = app
        end

        def mount_point(env)
          vm_name = env[:machine].config.vm.hostname
          config = env[:machine].provider_config
          mount_point = config.mount_point

          mount_point.each do |host,target|
            result = Vagrant::Util::Subprocess.execute("multipass", "mount", "#{host}", "#{vm_name}:#{target}")

            fail Errors::VmRegisteringMountError, stderr:result.stderr unless result.exit_code == 0
          end
        end

        def create_cloud_config(env)
          config = env[:machine].provider_config
          cloud_init = config.cloud_init
          ssh_authorized_keys = load_ssh_authorized_keys(env)

          unless ssh_authorized_keys.empty?
            name = (env[:machine].config.ssh.username || "vagrant")

            cloud_init["groups"] = [
              name
            ]

            cloud_init["users"] = [
              "default",
              {
                "name" => name,
                "primary_group" => name,
                "groups" => ["adm", "users"],
                "lock_passwd" => false,
                "passwd" => SecureRandom.hex,
                "sudo" => "ALL=(ALL) NOPASSWD:ALL",
                "shell" => "/bin/bash",
                "ssh_authorized_keys" => ssh_authorized_keys
              }
            ]

            cloud_init["ssh_authorized_keys"] = load_ssh_authorized_keys(env)
          end
        end

        def load_ssh_authorized_keys(env)
          ssh_authorized_keys = []

          (env[:machine].config.ssh.private_key_path || []).each do |private_key_path|
            public_key_path = "#{private_key_path}.pub"

            if File.file?(public_key_path)
              File.open(public_key_path).each do |line|
                line = line.strip
                unless line.empty?
                  ssh_authorized_keys << line
                end
              end
            end
          end
          
          if ssh_authorized_keys.empty?
            ssh_authorized_keys << "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
          end

          return ssh_authorized_keys
        end

        def call(env)
          config = env[:machine].provider_config
          vm_name = env[:machine].config.vm.hostname
          cloud_init = ""

          if config.is_vm_exists(vm_name)
            raise Errors::VmImageExistsError, :message => "#{vm_name} exists!"
          end

          begin
            multipass_cmd = [
              'multipass',
              'launch',
              '-n',
              vm_name
            ]

            create_cloud_config(env)

            unless config.hd_size.nil?
              multipass_cmd << '--disk'
              multipass_cmd << config.hd_size
            end

            unless config.memory_mb.nil?
              multipass_cmd << '--mem'
              multipass_cmd << "#{config.memory_mb}M"
            end

            unless config.cpu_count.nil?
              multipass_cmd << '--cpus'
              multipass_cmd << config.cpu_count.to_s
            end

            unless config.cloud_init.empty?
              cloud_init = Tempfile.open(["cloud-init-#{config.image_name}", '.yaml'])
              cloud_init.write(config.cloud_init.to_yaml)
              cloud_init.close

              multipass_cmd << '--cloud-init'
              multipass_cmd << cloud_init.path
            end

            multipass_cmd << config.image_name unless config.image_name.nil?

            result = Vagrant::Util::Subprocess.execute(*multipass_cmd)
          ensure
            cloud_init.delete unless config.cloud_init.empty?
          end

          raise Errors::VmRegisteringError, stderr: result.stderr unless result.exit_code?

          mount_point(env)

          env[:machine].id = vm_name

          @app.call env
        end
      end
    end
  end
end
