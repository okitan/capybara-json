require 'spec_helper'

describe "to require 'capybara/json'" do
  it 'should register driver' do
    Capybara.drivers.should have_key(:rack_test_json)
  end
end

describe Capybara::Json do
  include described_class

  before(:all) do
    Capybara.app = JsonTestApp
    Capybara.current_driver = :rack_test_json
  end

  after(:all) do
    Capybara.app = nil
    Capybara.current_driver = Capybara.default_driver
  end

  %w[ get delete ].each do |method|
    it "register #{method}" do
      __send__(method, '/')
      body.should == { 'Hello world!' => 'Hello world!' }
    end
  end

  %w[ post put ].each do |method|
    it "register #{method}" do
      __send__(method, '/', {})
      body.should == { 'Hello world!' => 'Hello world!' }
    end

    it "#{method} send json" do
      json = { "some" => "args" }
      __send__(method, '/env', json)

      body['content_type'].should =~ %r"application/json"
      body['rack.input'].should == MultiJson.encode(json)
    end
  end
end
