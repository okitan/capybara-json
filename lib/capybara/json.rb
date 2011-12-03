require 'capybara'

module Capybara
  module RackTestJson
    autoload :Driver, 'capybara/rack_test_json/driver'
  end
end

Capybara.register_driver :rack_test_json do |app|
  Capybara::RackTestJson::Driver.new(app)
end
