# -*- encoding: utf-8 -*-
require File.expand_path('../lib/assaydepot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher Petersen"]
  gem.email         = ["christopher.petersen@gmail.com"]
  gem.description   = %q{This is the first version of Assay Depot's Ruby SDK. It provides read access to Services and Vendors through assaydepot.com's JSON API.}
  gem.summary       = %q{Provides read access to Assay Depot's Services and Vendors.}
  gem.homepage      = "https://github.com/assaydepot/assaydepot-rb"

  gem.add_dependency('json')
  gem.add_dependency('uri-query_params')

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
