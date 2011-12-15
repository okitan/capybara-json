require 'capybara/spec/driver'

# this code is written in capybara's spec/spec_helper
alias :running :lambda

[ 'driver', 'driver with header support' ].each do |shared|
  RSpec.world.shared_example_groups.delete(shared)
end

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
      @driver.body.should include('Hello world!')
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


%w[ post put ].each do |method|
  shared_examples_for "driver to #{method} json" do
    it 'should set content type as json to request' do
      @driver.__send__(method, '/env', {})
      @driver.body['content_type'].should =~ %r"^application/json"
    end
    
    it 'should set content length' do
      json = { :some => :args }
      
      @driver.__send__(method, '/env', json)
      @driver.body['content_length'].to_i.should == MultiJson.encode(json).length
    end
    
    it 'should post body' do
      json = { :some => :args }
      
      @driver.__send__(method, '/env', json)
      @driver.body['rack.input'].should == MultiJson.encode(json)
    end
  end
end

shared_examples_for 'driver for client error' do
  it 'should not raise exception' do
    expect { @driver.get('/errors/400') }.should_not raise_exception
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
end

shared_examples_for 'driver for server error' do
  it 'should not raise exception' do
    expect { @driver.get('/errors/500') }.should_not raise_exception
  end

  it 'should make the status_code available' do
    @driver.get('/errors/500')
    @driver.status_code.should == 500
  end
end
