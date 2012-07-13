require 'capybara/spec/test_app'

# for capybara < 1.0
module Capybara
  class Server
    class Identify
      def call(env)
        if env["PATH_INFO"] == "/__identify__"
          #[200, {}, @app.object_id.to_s]
          [200, {}, [ @app.object_id.to_s] ]
        else
          @app.call(env)
        end
      end
    end
  end
end


class JsonTestApp < TestApp
  def invoke
    res = catch(:halt) { yield }

    res = [ MultiJson.dump(res => res) ] if Fixnum === res or String === res
    res = [ MultiJson.dump(res) ] if Hash === res
    if Array === res and Fixnum === res.first
      status(res.shift)
      body(res.pop)
      headers(*res)
    elsif res.respond_to? :each
      content_type :json
      body res
    end
  end

  %w[ get post put delete ].each do |method|
    __send__(method, '/') do
      'Hello world!'
    end

    # rack specifications
    # http://rack.rubyforge.org/doc/SPEC.html
    __send__(method, '/env') do
      envs = %w[ REQUEST_METHOD PATH_INFO QUERY_STRING CONTENT_TYPE CONTENT_LENGTH rack.url_scheme ]\
               .inject({}) do |hash, key|
        hash[key.downcase] = env[key]
        hash
      end
      headers = env.select {|key, value| key.start_with?('HTTP_') }.inject({}) do |hash, (key, value)|
        hash[key.sub('HTTP_', '')] = value
        hash
      end

      envs.merge('params' => params, 'headers' => headers, 'rack.input' => env['rack.input'].string)
    end
  end

  get '/errors/:status_code' do |status_code|
    status status_code.to_i
    { 'status_code' => status_code.to_i }
  end
end
