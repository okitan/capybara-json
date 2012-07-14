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

    def resolve_path(path)
      if page.respond_to?(:server) && server = page.server # for Capybara 2.0
        unless path =~ /^http/
          url = (Capybara.app_host || "http://#{server.host}:#{server.port}") + path
        else
          url = path
        end

        if Capybara.always_include_port
          uri = URI.parse(url)
          uri.port = server.port if uri.port == uri.default_port
          url = uri.to_s
        end
        url
      else
        path
      end
    end

    %w[ get get! delete delete! ].each do |method|
      module_eval %{
        def #{method}(path, params = {}, env = {})
          page.driver.#{method}(resolve_path(path), params, env)
        end
      }
    end

    %w[ post post! put put! ].each do |method|
      module_eval %{
        def #{method}(path, json, env = {})
          page.driver.#{method}(resolve_path(path), json, env)
        end
      }
    end

    def json
      page.driver.json
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
