require 'multi_json'

class Capybara::RackTestJson::Driver < Capybara::RackTest::Driver
  def body
    MultiJson.decode(source)
  end
end
