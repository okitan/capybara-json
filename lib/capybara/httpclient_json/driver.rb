require 'httpclient'

class Capybara::HTTPClientJson::Driver < Capybara::Driver::Base
  attr_reader :app, :current_url, :rack_server, :response

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
  alias parsed_body body

  def response_headers
    response.headers
  end
  alias headers response_headers

  def cookies
    response.cookies
  end

  def set_cookie(cookie, uri)
    @client = nil
    c = WebAgent::Cookie.new
    c.parse(cookie, uri)
    client.cookie_manager.add(c)
  end

  def verify_mode(value)
    client.ssl_config.verify_mode = value
  end

  def set_client_cert_file(cert_file_path, key_file_path, password)
    client.ssl_config.client_cert = OpenSSL::X509::Certificate.new(File.read(cert_file_path))
    client.ssl_config.client_key = OpenSSL::PKey::RSA.new(File.read(key_file_path), password)
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def get(url, params = {}, headers = {}, options = true) # follow_redirect
    process :get, url, params, headers, options
  end
  alias visit get

  def post(url, json, headers = {}, options = true) # follow_redirect
    json = MultiJson.encode(json) unless json.is_a?(String)
    headers['Content-Type'] = "application/json; charset=#{json.encoding.to_s.downcase}"
    process :post, url, json, headers, options
  end
  alias post_json post

  def put(url, json, headers = {})
    json = MultiJson.encode(json) unless json.is_a?(String)
    headers['Content-Type'] = "application/json; charset=#{json.encoding.to_s.downcase}"
    process :put, url, json, headers
  end
  alias put_json put

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

  %w[ post put post_json put_json ].each do |method|
    class_eval %{
      def #{method}!(url, json, headers = {})
        handle_error { #{method}(url, json, headers) }
      end
      }
  end

  def reset!
    @client = nil
    @response = nil
    @current_uri = nil
  end
  alias clear_all reset!

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
