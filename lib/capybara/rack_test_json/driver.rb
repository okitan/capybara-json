require 'multi_json'

class Capybara::RackTestJson::Driver < Capybara::RackTest::Driver
  def body
    MultiJson.decode(source) || {}
  end
  

  %w[ post put ].each do |method|
    class_eval %{
      def #{method}(path, json, env = {})
        json = MultiJson.encode(json) unless json.is_a?(String)
        
        request_env = {
          'CONTENT_LENGTH' => json.size,
          'CONTENT_TYPE'   => "application/json; charset=\#{json.encoding.to_s.downcase}", 
          'rack.input'     => StringIO.new(json)
        }.merge(env)
        
        super(path, {}, request_env)
      end
    }
  end
end
