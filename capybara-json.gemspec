# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "capybara-json"
  s.version     = File.read(File.expand_path('VERSION', File.dirname(__FILE__))).chomp
  s.authors     = ["okitan", "sonots"]
  s.email       = ["okitakunio@gmail.com", "sonots@gmail.com"]
  s.homepage    = "http://github.com/okitan/capybara-json"
  s.summary     = %q{for testing json-api}
  s.description = %q{for testing json-api}

  s.rubyforge_project = "capybara-json"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capybara"
  s.add_runtime_dependency "httpclient", "~> 2.2"
  s.add_runtime_dependency "multi_json", "~> 1.3"

  # for testing
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.11"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "thin"
  s.add_development_dependency "yajl-ruby"
  s.add_development_dependency "autowatchr"

  # for debug
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "tapp"
end
