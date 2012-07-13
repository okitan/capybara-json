require "bundler/setup"

require "pry"
require "tapp"

ROOT = File.dirname(__FILE__)

require "capybara"
if Capybara::VERSION =~ /^2/
  require "capybara2/spec_helper"
else
  require "capybara/spec_helper"
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end
