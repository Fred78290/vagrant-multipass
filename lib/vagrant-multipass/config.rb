require "vagrant"

module VagrantPlugins
  module Multipass
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :hd_size
      attr_accessor :memory_mb
      attr_accessor :cpu_count
      attr_accessor :network
      attr_accessor :nic_inversed
      attr_accessor :image_name
      attr_accessor :cloud_init

      # The defined network adapters.
      #
      # @return [Hash]
      attr_reader :network_adapters
 
      def initialize
        @cloud_init = {}
        @network_adapters = {}

        @hd_size = UNSET_VALUE
        @memory_mb = UNSET_VALUE
        @cpu_count = UNSET_VALUE
        @image_name = UNSET_VALUE
        @nic_inversed = UNSET_VALUE
      end
      
      def merge(other)
        super.tap do |result|
          c = @cloud_init.merge(other.cloud_init)
          result.instance_variable_set(:@cloud_init, c)
        end
      end

      def finalize!
        @hd_size = nil if @hd_size == UNSET_VALUE
        @memory_mb = nil if @memory_mb == UNSET_VALUE
        @cpu_count = nil if @cpu_count == UNSET_VALUE
        @image_name = nil if @image_name == UNSET_VALUE
        @nic_inversed = false if @nic_inversed == UNSET_VALUE
      end

      def is_vm_exists(vm_name)
        result = Vagrant::Util::Subprocess.execute("multipass", "info", vm_name)

        return result.exit_code == 0
      end
  
      # This defines a network adapter that will be added to the VirtualBox
      # virtual machine in the given slot.
      #
      # @param [Integer] slot The slot for this network adapter.
      # @param [Symbol] type The type of adapter.
      def network_adapter(slot, type, **opts)
        @network_adapters[slot] = [type, opts]
      end

      def validate(_machine)
        errors = _detected_errors
                
        { "multipass Provider" => errors }
      end
    end
  end
end
