# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require 'gigest/version'

Gem::Specification.new do |gem|
  gem.name          = "gigest"
  gem.version       = Gigest::VERSION
  gem.authors       = ["Winston Teo"]
  gem.email         = ["winston.yongwei+gigest@gmail.com"]
  gem.homepage      = "https://github.com/winston/gigest"
  gem.summary       = "GIthubGEmSTats. Discover Gems usage for a GitHub user or org."
  gem.description   = "Inspects Gemfiles across all repos for a GitHub user or org and generates Gem usage statistics."

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "octokit", "~> 2.0"

  # Add Rake dependency for Travis..
  gem.add_development_dependency "rake"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "multi_json"

  gem.license = 'MIT'
end
