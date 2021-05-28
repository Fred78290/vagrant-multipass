#!/bin/bash

vagrant plugin uninstall vagrant-multipass
rm vagrant-multipass-0.1.1.gem
gem build vagrant-multipass.gemspec
vagrant plugin install vagrant-multipass-0.1.1.gem