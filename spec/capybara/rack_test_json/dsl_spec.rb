require 'spec_helper'

describe Capybara::RackTestJson do
  before { @driver = :rack_test_json }

  it_behaves_like 'dsl'
  it_behaves_like "dsl with redirect support"
  it_behaves_like "dsl not to follow redirect"
end
