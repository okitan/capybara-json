# this code is written in capybara's spec/spec_helper
alias :running :lambda

shared_examples_for 'driver' do
  describe '#visit' do
    it "should move to another page" do
      @driver.visit('/')
      @driver.body.should include('Hello world!')
      @driver.visit('/foo')
      @driver.body.should include('Another World')
    end

    it "should show the correct URL" do
      @driver.visit('/foo')
      @driver.current_url.should include('/foo')
    end
  end

  describe '#body' do
    it "should return json reponses" do
      @driver.visit('/')
      @driver.body.should be_a(Hash)
      @driver.body.should include('Hello world!')
    end
    # pending encoding
  end

  context '#source' do
    it "should return raw reponse" do
      @driver.visit('/')
      @driver.source.should be_a(String)
      @driver.source.should include('Hello world!')
    end
  end

  describe '#json' do
    it "should return json reponses" do
      @driver.visit('/')
      @driver.json.should be_a(Hash)
      @driver.json.should include('Hello world!')
    end
    # pending encoding
  end
  # TODO: find by jsonpath?
end

shared_examples_for 'driver with header support' do
  it "should make headers available through response_headers" do
    @driver.visit('/')
    @driver.response_headers['Content-Type'].should =~ /^application\/json/
  end
end

shared_examples_for 'driver with custom header support' do
  it "should send custom header" do
    @driver.get('/env', {}, { 'X-Custom-Header' => 'custom header'})
    @driver.body['headers']['X_CUSTOM_HEADER'].should == 'custom header'
  end
end

shared_examples_for "driver with status code support" do
  it "should make the status code available through status_code" do
    @driver.visit('/with_simple_html')
    @driver.status_code.should == 200
  end
end

shared_examples_for "driver with cookies support" do
  describe "#reset!" do
    it "should set and clean cookies" do
      @driver.visit('/get_cookie')
      @driver.raw_json.should_not include('test_cookie')

      @driver.visit('/set_cookie')
      @driver.body.should include('Cookie set to test_cookie')

      @driver.visit('/get_cookie')
      @driver.body.should include('test_cookie')

      @driver.reset!
      @driver.visit('/get_cookie')
      @driver.raw_json.should_not include('test_cookie')
    end
  end
end

shared_examples_for "driver with infinite redirect detection" do
  it "should follow 5 redirects" do
    @driver.visit('/redirect/5/times')
    @driver.body.should include('redirection complete')
  end

  it "should not follow more than 5 redirects" do
    running do
      @driver.visit('/redirect/6/times')
    end.should raise_error(Capybara::InfiniteRedirectError)
  end
end

shared_examples_for "driver with redirect support" do
  it "should update current_url" do
    @driver.get "/redirect"
    URI.parse(@driver.current_url).path.should == "/landed"
  end
end

shared_examples_for "driver not to follow redirect" do
  it "should not follow redirect" do
    @driver.get "/redirect"
    @driver.status_code.should == 302
    URI.parse(@driver.current_url).path.should == "/redirect"
    URI.parse(@driver.response_headers["Location"]).path.should == "/redirect_again"
  end
end

%w[ post put ].each do |method|
  shared_examples_for "driver to #{method} json" do
    it 'should set content type as json to request' do
      @driver.__send__(method, '/env', {})
      @driver.body['content_type'].should =~ %r"^application/json"
    end

    it "should actualy #{method}" do
      @driver.__send__(method, '/env', {})
      @driver.body["request_method"].should == method.upcase
    end

    it 'should set content length' do
      json = { :some => :args }

      @driver.__send__(method, '/env', json)
      @driver.body['content_length'].to_i.should == MultiJson.dump(json).length
    end

    it 'should post body' do
      json = { :some => :args }

      @driver.__send__(method, '/env', json)
      @driver.body['rack.input'].should == MultiJson.dump(json)
    end
  end
end

shared_examples_for 'driver for client error' do
  it 'should not raise exception' do
    expect { @driver.get('/errors/400') }.not_to raise_exception
  end

  it 'should make the status code available' do
    @driver.get('/errors/400')
    @driver.status_code.should == 400
  end

  it 'should make the response header available' do
    @driver.get('/errors/400')
    @driver.response_headers['Content-Type'].should =~ /^application\/json/
  end

  it 'should make the body available' do
    @driver.get('/errors/400')
    @driver.body['status_code'].should == 400
  end

  it 'should raise error using bang!' do
    expect { @driver.get!('/errors/400') }.to raise_exception(Capybara::Json::Error)
  end
end

shared_examples_for 'driver for server error' do
  it 'should not raise exception' do
    expect { @driver.get('/errors/500') }.not_to raise_exception
  end

  it 'should make the status_code available' do
    @driver.get('/errors/500')
    @driver.status_code.should == 500
  end

  it 'should raise error using bang!' do
    expect { @driver.get!('/errors/500') }.to raise_exception(Capybara::Json::Error)
  end
end
