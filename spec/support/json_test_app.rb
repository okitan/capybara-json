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
end
