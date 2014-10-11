module Capybara
  module Json
    module Dsl
      def self.included(base)
        base.extend(self)
      end

      %w[ get get! delete delete! ].each do |method|
        module_eval <<-DEF, __FILE__, __LINE__ + 1
        def #{method}(path, params = {}, env = {})
          page.driver.#{method}(path, params, env)
        end
        DEF
      end

      %w[ post post! put put! patch patch! ].each do |method|
        module_eval <<-DEF, __FILE__, __LINE__ + 1
        def #{method}(path, json, env = {})
          page.driver.#{method}(path, json, env)
        end
        DEF
      end

      %w[ raw_json json source body status_code response_headers ].each do |method|
        define_method(method) do
          page.driver.__send__(method)
        end
      end
    end
  end
end
