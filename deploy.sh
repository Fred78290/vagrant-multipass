#!/bin/bash

vagrant plugin uninstall vagrant-multipass
rm vagrant-multipass-0.1.2.gem
gem build vagrant-multipass.gemspec
vagrant plugin install vagrant-multipass-0.1.2.gem