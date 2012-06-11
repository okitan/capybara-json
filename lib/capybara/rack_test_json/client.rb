require 'rack/test'

module Capybara::RackTestJson
  class Client
    include Rack::Test::Methods

    attr_accessor :app, :options

    def initialize(app, options)
      @app, @options = app, options
    end

    %w[ get post put delete ].each do |method|
      module_eval %{
        def #{method}(uri, params = {}, env = {}, &block)
          env.merge!(:method => "#{method.upcase}", :params => params)
          if options[:follow_redirect]
            request_with_follow_redirect(uri, env, &block)
          else
            request(uri, env)
          end
        end
      }
    end

    def request_with_follow_redirect(uri, env)
      request(uri, env)
      (5+1).times do
        if last_response.redirect?
          request(last_response["Location"], env.merge(:method => "GET"))
        else
          return
        end
      end

      # 6 times redirect cause InfiniteRedirectError
      raise Capybara::InfiniteRedirectError,
      "redirected more than 5 times, check for infinite redirects."
    end
  end
end
