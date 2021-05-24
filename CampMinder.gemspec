# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "CampMinder/version"

Gem::Specification.new do |spec|
  spec.name          = "CampMinder"
  spec.version       = CampMinder::VERSION
  spec.authors       = ["Dirk Kelly", "Nathan Harper", "Aaron Todd"]
  spec.email         = ["dkelly@interexchange.org", "engineering+nharper@interexchange.org", "atodd@interexchange.org"]
  spec.summary       = "Interface for CampMinder ClientLink API."
  spec.homepage      = "https://github.com/interexchange/campminder-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5", "< 4"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "dotenv", "~> 1.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rails", "~> 6.0.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rspec-mocks", "~> 3.1"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "timecop", "~> 0.7"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "active_model_serializers", "= 0.9.2"
  spec.add_dependency "loofah", "~> 2.3"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "sprockets", "~> 3.7.2" # for security - https://blog.heroku.com/rails-asset-pipeline-vulnerability
  spec.add_dependency "virtus", "~> 1.0"
end
