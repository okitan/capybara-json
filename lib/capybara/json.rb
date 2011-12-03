require 'capybara'

module Capybara
  module JSON
    VERSION = File.read(File.expand_path('../../VERSION', File.dirname(__FILE__)))
  end
end
