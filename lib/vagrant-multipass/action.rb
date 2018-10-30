require "vagrant"
require "vagrant/action/builder"

module VagrantPlugins
  module Multipass
    module Action
      include Vagrant::Action::Builtin

      # Vagrant commands
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsRunning do |env, b2|
            if [:result]
                b2.use PowerOff
                next
            end
          end
          b.use Destroy
        end
      end

      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Call, IsRunning do |env1, b3|
              if !env1[:result]
                b3.use MessageNotRunning
                next       
              end
              
              b3.use Provision
              b3.use SyncedFolders 
              b3.use SetHostname
            end        
          end
        end
      end

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Call, IsRunning do |env1, b3|
              if !env1[:result]
                b3.use MessageNotRunning
                next
              end
              
              b3.use SSHExec
            end
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Call, IsRunning do |env1, b3|
              if !env1[:result]
                b3.use MessageNotRunning
                next
              end
              
              b3.use SSHRun
            end
          end
        end
      end

      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Call, IsRunning do |env1, b3|
              if !env1[:result]
                b3.use MessageNotRunning
                next
              end
              
              b3.use PowerOff
              b3.use PowerOn
            end
          end
       end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          # Handle box_url downloading early so that if the Vagrantfile
          # references any files in the box or something it all just
          # works fine.
          b.use Call, Created do |env, b2|
            if !env[:result]
              b2.use HandleBox
            end
          end
          
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if env[:result]
              b2.use MessageAlreadyCreated
              next
            end

            b2.use Clone
          end
          b.use Call, IsRunning do |env, b2|
            if !env[:result]
              b2.use PowerOn
            end
          end
          
#          b.use Network
          b.use Provision          
          b.use SyncedFolders          
          b.use SetHostname
        end
      end

      def self.action_halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Call, IsRunning do |env, b3|
              if !env[:result]
                b3.use MessageNotRunning
                next
              end
              
              b3.use PowerOff
            end
          end
        end
      end

      # Multipass specific actions
      def self.action_get_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use GetState
        end
      end

      def self.action_get_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use GetSshInfo
        end
      end

      # autoload
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :Clone, action_root.join("clone")
      autoload :Created, action_root.join("created")
      autoload :Destroy, action_root.join("destroy")
      autoload :GetSshInfo, action_root.join("get_ssh_info")
      autoload :GetState, action_root.join("get_state")
      autoload :IsCreated, action_root.join("is_created")
      autoload :IsRunning, action_root.join("is_running")
      autoload :MessageAlreadyCreated, action_root.join("message_already_created")
      autoload :MessageNotCreated, action_root.join("message_not_created")
      autoload :MessageNotRunning, action_root.join("message_not_running")
      autoload :PowerOff, action_root.join("power_off")
      autoload :PowerOn, action_root.join("power_on")
#      autoload :Network, action_root.join("network")
    end
  end
end
