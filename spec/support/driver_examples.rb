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
