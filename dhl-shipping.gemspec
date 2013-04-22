# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhl-shipping/version'

Gem::Specification.new do |gem|
  gem.name          = "dhl-shipping"
  gem.version       = Dhl::Shipping::VERSION
  gem.authors       = ["Matthew Nielsen"]
  gem.email         = ["mnielsen@deseretbook.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'httparty', '~>0.10.2'
  gem.add_dependency 'multi_xml', '~>0.5.3'
  gem.add_dependency 'builder', '~> 2.0'

  gem.add_development_dependency 'rake', '10.0.4'
  gem.add_development_dependency 'rspec', '2.13.0'
  gem.add_development_dependency 'rspec-must', '0.0.1'
  gem.add_development_dependency 'webmock', '1.11.0'
end
