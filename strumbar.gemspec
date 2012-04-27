# -*- encoding: utf-8 -*-
require File.expand_path('../lib/strumbar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Nordman", "Matthew Wilson"]
  gem.email         = ["anordman@majorleaguegaming.com", "mwilson@majorleaguegaming.com"]
  gem.description   = %q{An instrumentation utility.}
  gem.summary       = %q{Helper library to strum along in your application.}
  gem.homepage      = "http://instrument.majorleaguegaming.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "strumbar"
  gem.require_paths = ["lib"]
  gem.version       = Strumbar::VERSION

  gem.add_dependency 'activesupport'
  gem.add_dependency 'statsd'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
