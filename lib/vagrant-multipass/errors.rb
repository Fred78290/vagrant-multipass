require "vagrant"

module VagrantPlugins
  module Multipass
    module Errors
      class VagrantMultipassError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_multipass.errors")
      end

      class OvfError < VagrantMultipassError
        error_key(:ovf_error)
      end

      class VmNotExistsError < VagrantMultipassError
        error_key(:vm_notfound_error)
      end

      class RsyncError < VagrantMultipassError
        error_key(:rsync_error)
      end

      class VmRegisteringError < VagrantMultipassError
        error_key(:vm_registering_error)
      end

      class VmImageExistsError < VagrantMultipassError
        error_key(:vm_image_exists)
      end

      class VMNicCreateError < VagrantMultipassError
        error_key(:nic_error)
      end
      class VMHdCreateError < VagrantMultipassError
        error_key(:add_drive_error)
      end
      class VMHdExpandError < VagrantMultipassError
        error_key(:expand_drive_error)
      end
    end
  end
end


