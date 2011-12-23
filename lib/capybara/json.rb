require 'capybara'
require 'capybara/dsl'

require 'multi_json'

module Capybara
  module Json
    def self.to_include
      Capybara.const_defined?("DSL") ? Capybara::DSL : Capybara
    end

    def self.included(base)
      base.__send__(:include, to_include) unless base < to_include
      base.extend(self)
    end

    %w[ get delete ].each do |method|
      module_eval %{
        def #{method}(path, params = {}, env = {})
          page.driver.#{method}(path, params, env)
        end
      }
    end

    %w[ post put ].each do |method|
      module_eval %{
        def #{method}(path, json, env = {})
          page.driver.#{method}(path, json, env)
        end
      }
    end

    autoload :Error, 'capybara/json/error'
  end

  module RackTestJson
    autoload :Driver, 'capybara/rack_test_json/driver'
  end

  module HTTPClientJson
    autoload :Driver, 'capybara/httpclient_json/driver'
  end
end

Capybara.register_driver :rack_test_json do |app|
  Capybara::RackTestJson::Driver.new(app)
end

Capybara.register_driver :httpclient_json do  |app|
  Capybara::HTTPClientJson::Driver.new(app)
end
