require 'spec_helper'

# this code is written in capybara's spec/spec_helper
alias :running :lambda

klass = Capybara::RackTestJson::Driver

describe klass do
  before { @driver = described_class.new(JsonTestApp) }

  it_should_behave_like 'driver'
  it_should_behave_like 'driver with header support'
  it_should_behave_like 'driver with status code support'
  it_should_behave_like 'driver with cookies support'
  it_should_behave_like 'driver with infinite redirect detection'
end
