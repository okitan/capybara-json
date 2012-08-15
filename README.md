# capybara-json [![Build Status](https://secure.travis-ci.org/okitan/capybara-json.png?branch=master)](http://travis-ci.org/okitan/capybara-json) [![Dependency Status](https://gemnasium.com/okitan/capybara-json.png)](https://gemnasium.com/okitan/capybara-json)

testing ruby: 1.9.2, 1.9.3 and ruby-head;  Capybara: < 1.0 and > 1.0

## About capybara-json

capybara-json provides the same interface to testing JSON API (both local and remote)

Capybara is an acceptance test framework, and it has no interest with client error(4xx response).

## USAGE

```ruby
require 'capybara/json'
include Capybara::Json

Capybara.current_driver = :rack_test_json
post '/', { "this is" => "json" } # POST '/'
json   #=> parsed json response
source #=> raw response body
get  '/errors/400'
status_code #=> 400
get! '/errors' #=> raise Capybara::Json::Error

Capybara.current_driver = :httpclient_json
Capybara.app_host = 'http://example.com'
post '/', { "this is" => "json" } # POST 'http://example.com/'
json   #=> parsed json response
source #=> raw response body
get  '/errors/400'
status_code #=> 400
get! '/errors' #=> raise Capybara::Json::Error
```
