require 'multi_json'

to_inherit = Capybara.const_defined?("RackTest") ? Capybara::RackTest::Driver : Capybara::Driver::RackTest

class Capybara::RackTestJson::Driver < to_inherit
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
