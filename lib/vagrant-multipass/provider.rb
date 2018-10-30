require "vagrant"

module VagrantPlugins
  module Multipass
    class Provider < Vagrant.plugin("2", :provider)
      def initialize(machine)
        @machine = machine
      end

      def action(name)
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def ssh_info
        env = @machine.action("get_ssh_info")
        env[:machine_ssh_info]
      end

      def state
        env = @machine.action("get_state")

        state_id = env[:machine_state_id]

        short = state_id.to_s.gsub("_", " ")
        long  = I18n.t("vagrant.commands.status.#{state_id}")

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        id = @machine.id.nil? ? "new" : @machine.id
        "multipass (#{id})"
      end
    end
  end
end
