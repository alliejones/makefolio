# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'makefolio/version'

Gem::Specification.new do |gem|
  gem.name          = "makefolio"
  gem.version       = Makefolio::VERSION
  gem.authors       = ["Allie Jones"]
  gem.email         = ["allie.jones@gmail.com"]
  gem.description   = %q{Static portfolio generator}
  gem.summary       = %q{Static portfolio generator}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ["makefolio"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "growl"
  gem.add_development_dependency "rspec-html-matchers"
  gem.add_development_dependency "fakefs"

  gem.add_runtime_dependency "rdiscount"
end
