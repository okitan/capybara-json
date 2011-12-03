require 'autowatchr'

Autowatchr.new(self) do |config|
  config.ruby      = 'clear && rspec'
  config.test_dir  = 'spec'
  config.test_re   = "^#{config.test_dir}/(.*)_spec\.rb$"
  config.test_file = '%s_spec.rb'
end


