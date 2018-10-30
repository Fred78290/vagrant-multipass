# -*- mode: ruby -*-
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vagrant-multipass/version"

Gem::Specification.new do |spec|
  spec.name          = "vagrant-multipass"
  spec.version       = VagrantPlugins::Multipass::VERSION
  spec.authors       = ["Frédéric BOLTZ"]
  spec.email         = ["frederic.boltz@gmail.com"]

  spec.summary       = "Canonical Multipass provider"
  spec.description   = "Enables Vagrant to manage machines with Canonical Multipass."
  spec.homepage      = "https://github.com/Fred78290/vagrant-multipass"
  spec.license       = "MIT"

  spec.required_rubygems_version = ">= 1.3.6"
  # spec.rubyforge_project         = "vagrant-aws"

  spec.add_development_dependency "bundler", '~> 1.16', '>= 1.16.1'
  #spec.add_runtime_dependency "fog", "~> 1.22"
  spec.add_runtime_dependency "iniparse", "~> 1.4", ">= 1.4.2"

  spec.add_development_dependency "rake", "~> 10.0"
  # rspec 3.4 to mock File
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rspec-its", '~> 1.2', '>= 1.2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
  
  # The following block of code determines the files that should be included
  # in the gem. It does this by reading all the files in the directory where
  # this gemspec is, and parsing out the ignored files from the gitignore.
  # Note that the entire gitignore(5) syntax is not supported, specifically
  # the "!" syntax, but it should mostly work correctly.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }
  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map!    { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end

  spec.files         = unignored_files
  spec.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  spec.require_path  = 'lib'
end
