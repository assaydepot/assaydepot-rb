# -*- encoding: utf-8 -*-
require File.expand_path('../lib/assaydepot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher Petersen", "Ron Ranauro"]
  gem.email         = ["chris@scientist.com", "ron@scientist.com"]
  gem.description   = %q{The Scientist Ruby SDK. It provides read access to Services and Suppliers through scientist.com's JSON API.}
  gem.summary       = %q{Provides read access to Assay Depot's Services and Vendors.}
  gem.homepage      = "https://github.com/assaydepot/assaydepot-rb"

  gem.add_dependency('json')
  gem.add_dependency('rack')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('oauth2')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "assaydepot"
  gem.require_paths = ["lib"]

  gem.version       = AssayDepot::VERSION
end
