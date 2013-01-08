require 'spec_helper'

[ :rack_test_json, :httpclient_json ].each do |driver|
  describe "to require 'capybara/json'" do
    it "should register driver #{driver}" do
      Capybara.drivers.should have_key(driver)
    end
  end
end
