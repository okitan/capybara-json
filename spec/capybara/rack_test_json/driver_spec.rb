require 'spec_helper'

klass = Capybara::RackTestJson::Driver

describe klass do
  before { @driver = described_class.new(JsonTestApp) }

  it_should_behave_like 'driver'
end
