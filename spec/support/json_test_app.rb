require 'capybara/spec/test_app'

class JsonTestApp < TestApp
  def invoke
    res = catch(:halt) { yield }

    res = [ MultiJson.encode(res => res) ] if Fixnum === res or String === res
    res = [ MultiJson.encode(res) ] if Hash === res
    if Array === res and Fixnum === res.first
      status(res.shift)
      body(res.pop)
      headers(*res)
    elsif res.respond_to? :each 
      content_type :json
      body res
    end
  end

  get '/' do
    'Hello world!'
  end

  # rack specifications
  # http://rack.rubyforge.org/doc/SPEC.html
  %w[ post put ].each do |method|
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
end
