module Capybara::Json::Driver
  class Base
    %w[ get post put delete get! post! put! delete!
        reset!
        current_url
        source body response_headers status_code
    ].each do |method|
      define_method(method) do
        raise NotImplementedError
      end
    end

    # for capybara > 2.0
    def needs_server?
      false
    end
  end
end
