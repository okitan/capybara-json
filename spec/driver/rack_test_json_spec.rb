require 'spec_helper'

klass = Capybara::RackTestJson::Driver

describe klass do
  before do
    @driver = described_class.new(TestApp)
  end
  it {}
end
