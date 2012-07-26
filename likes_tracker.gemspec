# -*- encoding: utf-8 -*-
require File.expand_path('../lib/likes_tracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrea Pavoni"]
  gem.email         = ["andrea.pavoni@gmail.com"]
  gem.description   = %q{track likes between models using Redis backend}
  gem.summary       = %q{LikesTracker tracks likes between ActiveModel compliant models using a Redis backend. Once you include this lib, you can add/remove likes from an object to another (eg: a User likes a Post), plus a bunch of useful method helpers.}
  gem.homepage      = "http://github.com/apeacox/likes_tracker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "likes_tracker"
  gem.require_paths = ["lib"]
  gem.version       = LikesTracker::VERSION

  gem.add_dependency 'rails', '>= 3.0.0'
  gem.add_dependency 'redis', '~> 3.0.1'

  s.add_development_dependency 'factory_girl_rails', '~> 3.5.0'
  s.add_development_dependency 'rspec-rails', '~> 2.10.0'


end
