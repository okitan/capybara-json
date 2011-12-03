# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybara/json"

Gem::Specification.new do |s|
  s.name        = "capybara-json"
  s.version     = Capybara::JSON::VERSION
  s.authors     = ["okitan"]
  s.email       = ["okitakunio@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{for testing json-api with capybara}
  s.description = %q{for testing json-api with capybara}

  s.rubyforge_project = "capybara-json"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  [ [ 'capybara' ],
  ].each do |gem, version|
    s.add_runtime_dependency gem, version
  end

  [ [ 'rspec', '~> 2.0' ],
  ].each do |gem, version|
    s.add_development_dependency gem, version
  end
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
