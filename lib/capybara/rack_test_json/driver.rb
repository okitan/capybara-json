class Capybara::RackTestJson::Driver < Capybara::Json::Driver::Base
  attr_reader :app, :options

  def initialize(app, options = {})
    @app, @options = app, { :follow_redirect => true }.merge(options)
  end

  def client
    @client ||= Capybara::RackTestJson::Client.new(app, options)
  end

  def last_request
    client.last_request
  end

  def last_response
    client.last_response
  end
  alias response last_response

  %w[ get delete ].each do |method|
    class_eval <<-DEF, __FILE__, __LINE__ + 1
      def #{method}(path, params = {}, env = {})
        client.#{method}(path, params, env_for_rack(env))
      end

      def #{method}!(path, params = {}, env = {})
        handle_error { #{method}(path, params, env) }
      end
    DEF
  end
  alias visit get

  %w[ post put patch ].each do |method|
    class_eval <<-DEF, __FILE__, __LINE__ + 1
      def #{method}(path, json, env = {})
        json = MultiJson.dump(json) unless json.is_a?(String)

        request_env = {
          'CONTENT_LENGTH' => json.size,
          'CONTENT_TYPE'   => "application/json; charset=\#{json.encoding.to_s.downcase}",
          'rack.input'     => StringIO.new(json)
        }.merge(env_for_rack(env))

        client.#{method}(path, {}, request_env)
      end

      def #{method}!(path, json, env = {})
        handle_error { #{method}(path, json, env) }
      end
    DEF
  end

  def current_url
    last_request.url
  end

  def raw_json
    last_response.body
  end
  alias source raw_json # almost deprecated
  alias html   raw_json # hack for capybara2

  def body
    MultiJson.load(source) || {}
  end

  def json
    MultiJson.load(source) || {}
  end

  def response_headers
    last_response.headers
  end

  def status_code
    last_response.status
  end

  def reset!
    @client = nil
  end

  protected
  def env_for_rack(env)
    env.inject({}) do |rack_env, (key, value)|
      env_key = key.upcase.gsub('-', '_')
      env_key = "HTTP_" + env_key unless env_key == "CONTENT_TYPE"
      rack_env[env_key] = value

      rack_env
    end
  end

  def handle_error(&block)
    yield
    raise(Capybara::Json::Error, last_response) if status_code >= 400
  end
end
