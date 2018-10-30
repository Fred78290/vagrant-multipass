# Vagrant Multipass Provider

This is a Vagrant plugin for [Canonical Multipass hypervisor](https://github.com/CanonicalLtd/multipass).

## Goal

Provide a vagrant plugin for fast test for multi VM environment

## Work in progress

Version 0.1.0.

- First release

## Prerequistes

You must install multipass on your host.

**NOTE:** This is a work in progress

Vagrant networking is not supported due multipass doesn't allow to manage network

## Plugin Installation

    git clone https://github.com/Fred78290/vagrant-multipass.git
    cd vagrant-multipass
    gem build vagrant-multipass.gemspec
    vagrant plugin install vagrant-multipass

## Create multipass fake box

    cd vagrant-multipass/box
    ./makebox.sh

## Vagrant user authentification

  The plugin use cloud-init process to create the vagrant user

  If you provide your ssh private key with *config.ssh.private_key_path*, the public key must be present also to be injected in image during the first boot

    config.ssh.private_key_path = ["#{ENV['HOME']}/.ssh/id_rsa"]

  "#{ENV['HOME']}/.ssh/id_rsa.pub will be uploaded via cloud-init

## Example Vagrantfile

    Vagrant.configure("2") do |config|
      config.vm.box = "multipass"
      config.vm.hostname = "multipass-vagrant-test"
      config.vm.synced_folder ".", "/vagrant", type: "rsync"

      # Can be omited
      config.ssh.username = "grunt"
      config.ssh.private_key_path = ["#{ENV['HOME']}/.ssh/id_rsa"]

      config.vm.provider "multipass" do |multipass, override|
        multipass.hd_size = "10G"
        multipass.cpu_count = 1
        multipass.memory_mb = 2048
        multipass.image_name = "bionic"
      end
    end

## Issues

https://github.com/Fred78290/vagrant-multipass/issues
