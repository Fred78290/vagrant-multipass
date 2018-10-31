# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	config.ssh.username = "vagrant"
	config.ssh.private_key_path = ["#{ENV['HOME']}/.ssh/id_rsa"]
	
	config.vm.synced_folder ".", "/vagrant", type: "rsync"
	config.vm.hostname = "multipass-test"
	config.vm.box = "multipass"
	
	config.vm.provider "multipass" do |multipass, override|
		multipass.hd_size = "10G"
		multipass.cpu_count = 1
		multipass.memory_mb = 2048
		multipass.image_name = "bionic"
	end

	(0..0).each do |i|
		vm_name = "multipass-test-#{i}"

	    config.vm.define "#{vm_name}" do |subconfig|
			subconfig.vm.hostname = vm_name

			subconfig.trigger.after :up do |trigger|
				trigger.info = "Get IP Address"
				trigger.ruby do |env, machine|
					puts machine.ssh_info
				end
			end

			subconfig.vm.provider "multipass" do |multipass, override|
				multipass.hd_size = "5G"
				multipass.cpu_count = 1
				multipass.memory_mb = 1024
				multipass.image_name = "bionic"
				multipass.mount_point = {
					"/Users" => "/Users"
				}
			end

			subconfig.vm.provision "provision for #{vm_name}", type: "shell", inline: "cat /etc/hosts"
		end
	end
end
