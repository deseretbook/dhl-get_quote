# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhl/get_quote/version'

Gem::Specification.new do |gem|
  gem.name          = "dhl-get_quote"
  gem.version       = Dhl::GetQuote::VERSION
  gem.authors       = ["Matthew Nielsen"]
  gem.email         = ["mnielsen@deseretbook.com"]
  gem.description   = %q{Get shipping quotes from DHL}
  gem.summary       = %q{Gem to interface with DHL's XML-PI shipping quote service.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'httparty', '~>0.10.2'
  gem.add_dependency 'multi_xml', '~>0.5.3'

  gem.add_development_dependency 'rake', '~>10.0.4'
  gem.add_development_dependency 'rake', '10.0.4'
  gem.add_development_dependency 'rspec', '2.13.0'
  gem.add_development_dependency 'rspec-must', '0.0.1'

end
