shared_context 'prepare_dsl' do
  include Capybara::Json

  before do
    Capybara.app = JsonTestApp
    Capybara.current_driver = @driver
    @default_follow_redirect = page.driver.options[:follow_redirect]
  end

  after do
    page.driver.options[:follow_redirect] = @default_follow_redirect
    Capybara.app = nil
    Capybara.current_driver = Capybara.default_driver
  end
end

shared_examples_for 'dsl' do
  include_context 'prepare_dsl'

  %w[ get get! delete delete! ].each do |method|
    it "register #{method}" do
      __send__(method, '/')
      body.should == { 'Hello world!' => 'Hello world!' }
    end
  end

  %w[ post post! put put! ].each do |method|
    it "register #{method}" do
      __send__(method, '/', {})
      body.should == { 'Hello world!' => 'Hello world!' }
    end

    it "#{method} send json" do
      json = { "some" => "args" }
      __send__(method, '/env', json)

      body['content_type'].should =~ %r"application/json"
      body['rack.input'].should == MultiJson.dump(json)
    end
  end

  %w[ raw_json source ].each do |method|
    it "register #{method}" do
      get('/', {})
      __send__(method).should == MultiJson.dump({ 'Hello world!' => 'Hello world!' })
    end
  end

  %w[ json body ].each do |method|
    it "register #{method}" do
      get('/', {})
      __send__(method).should == { 'Hello world!' => 'Hello world!' }
    end
  end
end

shared_examples_for 'dsl with redirect support' do
  include_context 'prepare_dsl'

  it "should update current_url" do
    page.driver.options[:follow_redirect] = true
    get "/redirect"
    URI.parse(current_url).path.should == "/landed"
  end
end

shared_examples_for "dsl not to follow redirect" do
  include_context 'prepare_dsl'

  it "should not follow redirect" do
    page.driver.options[:follow_redirect] = false
    get "/redirect"
    status_code.should == 302
    URI.parse(current_url).path.should == "/redirect"
    URI.parse(response_headers["Location"]).path.should == "/redirect_again"
  end
end
