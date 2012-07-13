require "bundler/setup"
require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  require "capybara"
  if Capybara::VERSION =~ /^2/
    spec.pattern = FileList["spec/capybara2/**/*_spec.rb"]
  else
    spec.pattern = FileList['spec/capybara/**/*_spec.rb']
  end
end

task :default => :spec
