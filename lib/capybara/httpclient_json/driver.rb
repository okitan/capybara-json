require 'httpclient'

class Capybara::HTTPClientJson::Driver < Capybara::Json::Driver::Base
  attr_reader :app, :current_url, :rack_server, :response, :cookies

  def client
    unless @client
      @client = HTTPClient.new
      @client.follow_redirect_count  = 5 + 1 # allows 5 redirection
      @client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    @client
  end

  def initialize(app)
    @app = app
    @rack_server = Capybara::Server.new(@app)
    @rack_server.boot if Capybara.run_server
  end

  def status_code
    response.code
  end

  def source
    response.body
  end

  def body
    MultiJson.decode(source) || {}
  end

  def response_headers
    response.headers
  end

  def get(url, params = {}, headers = {})
    process :get, url, params, headers, true # follow_redirect
  end
  alias visit get

  def post(url, json, headers = {})
    json = MultiJson.encode(json) unless json.is_a?(String)
    headers['Content-Type'] = "application/json; charset=#{json.encoding.to_s.downcase}"
    process :post, url, json, headers, true # follow_redirect
  end

  def put(url, json, headers = {})
    json = MultiJson.encode(json) unless json.is_a?(String)
    headers['Content-Type'] = "application/json; charset=#{json.encoding.to_s.downcase}"
    process :put, url, json, headers
  end

  def delete(url, params = {}, headers = {})
    process :delete, url, params, headers
  end

  %w[ get delete ].each do |method|
    class_eval %{
      def #{method}!(url, params = {}, env = {})
        handle_error { #{method}(url, params, env) }
      end
    }
  end

  %w[ post put ].each do |method|
    class_eval %{
      def #{method}!(url, json, headers = {})
        handle_error { #{method}(url, json, headers) }
      end
      }
  end

  def reset!
    @client = nil
  end

  protected
  def process(method, path, params = {}, headers = {}, options = {})
    @current_url = @rack_server.url(path)

    begin
      @response = client.__send__(method, @current_url, params, headers, options)
    rescue HTTPClient::BadResponseError => e
      if e.message == "retry count exceeded"
        raise Capybara::InfiniteRedirectError
      else
        @response = e.res
      end
    end
  end

  def handle_error(&block)
    yield
    raise(Capybara::Json::Error, response) if status_code >= 400
  end
end
