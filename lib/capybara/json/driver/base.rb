module Capybara::Json::Driver
  class Base
    %w[ get post put patch delete get! post! put! patch! delete!
        reset!
        current_url
        raw_json json source body response_headers status_code
    ].each do |method|
      define_method(method) do
        raise NotImplementedError
      end
    end
    def needs_server?; false; end
  end
end
