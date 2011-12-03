# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "capybara-json"
  s.version     = File.read(File.expand_path('VERSION', File.dirname(__FILE__))).chomp
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
    [ 'multi_json' ],
  ].each do |gem, version|
    s.add_runtime_dependency gem, version
  end

  [ [ 'rspec', '~> 2.8.0.rc' ],
    [ 'sinatra' ],
    [ 'yajl-ruby' ],
    [ 'autowatchr' ],
  ].each do |gem, version|
    s.add_development_dependency gem, version
  end
end
