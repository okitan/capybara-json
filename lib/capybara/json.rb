require 'capybara'
require 'capybara/dsl'

require 'multi_json'

module Capybara
  module Json
    def self.to_include
      ::Capybara.const_defined?("DSL") ? ::Capybara::DSL : ::Capybara
    end

    def self.included(base)
      base.__send__(:include, to_include) unless base < to_include
      base.extend(self)
    end

    %w[ get get! delete delete! ].each do |method|
      module_eval <<-DEF, __FILE__, __LINE__ + 1
        def #{method}(path, params = {}, env = {})
          page.driver.#{method}(path, params, env)
        end
      DEF
    end

    %w[ post post! put put! ].each do |method|
      module_eval <<-DEF, __FILE__, __LINE__ + 1
        def #{method}(path, json, env = {})
          page.driver.#{method}(path, json, env)
        end
      DEF
    end

    %w[ raw_json json ].each do |method|
      define_method(method) do
        page.driver.__send__(method)
      end
    end

    autoload :Error, 'capybara/json/error'

    module Driver
      autoload :Base, "capybara/json/driver/base"
    end
  end

  module RackTestJson
    autoload :Driver, 'capybara/rack_test_json/driver'
    autoload :Client, "capybara/rack_test_json/client"
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
