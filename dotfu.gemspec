# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotfu/version'

Gem::Specification.new do |spec|
  spec.name          = "dotfu"
  spec.version       = Dotfu::VERSION
  spec.authors       = ["Ernie Brodeur"]
  spec.email         = ["ebrodeur@ujami.net"]
  spec.description   = "Manage/sync/share dotfiles via github."
  spec.summary       = "See above."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bini"
  spec.add_runtime_dependency "git"
  spec.add_runtime_dependency "github_api"
  spec.add_runtime_dependency "slop"
  spec.add_runtime_dependency "yajl-ruby"
end
