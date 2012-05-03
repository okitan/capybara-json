require 'spec_helper'

klass = Capybara::HTTPClientJson::Driver

describe klass do
  before { @driver = described_class.new(JsonTestApp) }

  it_should_behave_like 'driver'
  it_should_behave_like 'driver with header support'
  it_should_behave_like 'driver with custom header support'
  it_should_behave_like 'driver with status code support'
  it_should_behave_like 'driver with cookies support'
  it_should_behave_like "driver with redirect support"
  it_should_behave_like 'driver with infinite redirect detection'

  it_should_behave_like 'driver to post json'
  it_should_behave_like 'driver to put json'

  it_should_behave_like 'driver for client error'
  it_should_behave_like 'driver for server error'
end
