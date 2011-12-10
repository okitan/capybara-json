# capybara-json

capybara-json provides the same interface to testing JSON API (both local and remote) 

Capybara is an acceptance test framework, and it has no interest with client error(4xx response).
testing web application 

## USAGE
    require 'capybara/json'
    Capybara.current_driver = :rack_test_json

    include Capybara::Json
    post '/', { "this is" => "json" } # POST { "this is": "json" } 
    body   #=> parsed json response
    source #=> raw response body

## ROADMAP

* 0.0.1
    * create :rack_test_json driver which supports normal json response (2xx, 3xx)
* 0.0.2
    * create :httpclient driver for remote testing
* 0.0.3
    * create :httpclient_json driver with the same interface with :rack_test_json in normal json response
* 0.1.0
    * ensure :rack_test_json and :httpclient_json has the same interface in error response (4xx, 5xx)
* 0.2.0
    * add jsonpath? interface to search response