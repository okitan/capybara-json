require 'spec_helper'

klass = Capybara::HTTPClientJson::Driver

describe klass do
  before { @driver = described_class.new(JsonTestApp) }

  it_behaves_like 'driver'
  it_behaves_like 'driver with header support'
  it_behaves_like 'driver with custom header support'
  it_behaves_like 'driver with status code support'
  it_behaves_like 'driver with cookies support'
  it_behaves_like "driver with redirect support"
  it_behaves_like 'driver with infinite redirect detection'

  it_behaves_like 'driver to post json'
  it_behaves_like 'driver to put json'

  it_behaves_like 'driver for client error'
  it_behaves_like 'driver for server error'
end

describe klass do
  before { @driver = described_class.new(JsonTestApp, :follow_redirect => false) }

  it_behaves_like "driver not to follow redirect"
end
