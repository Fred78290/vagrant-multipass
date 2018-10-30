source 'https://rubygems.org'

# Specify your gem's dependencies in vagrant-multipass.gemspec
gemspec

ENV['VAGRANT_VERSION'] = "v2.2.0"

group :development do
  if ENV['VAGRANT_VERSION']
    gem 'vagrant', :git => 'https://github.com/hashicorp/vagrant.git', tag: ENV['VAGRANT_VERSION']
  else
    gem 'vagrant', :git => 'https://github.com/hashicorp/vagrant.git'
  end

  gem 'vagrant-spec', :github => 'hashicorp/vagrant-spec'
  gem 'pry'
end

group :plugins do
  # gem "vagrant-multipass", path: "."
  gemspec
end
