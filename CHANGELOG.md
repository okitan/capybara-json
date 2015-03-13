## 0.4.0

* PATCH method support (Thanks to @xforty)

## 0.3.0
* Capybara 2.x support (Thanks to @sonots, @gkellogg)

## 0.2.4
* Added __FILE__ and __LINE__ so that pry can find generated methods (thanks to @mad_p)

## 0.2.3
* ENHANCEMENT
 * add json interface to get json

## 0.2.2
* BUGFIX
 * rack_test_json works POST, PUT, DELETE as well (thanks to @sonots)

## 0.2.1
* ENHANCEMENT
 * options to switch redirect

## 0.2.0
* stop using capybara/rack_test/driver

## 0.1.2
* BUGFIX
   * I forgot to add get! etc to Capybara::DSL

## 0.1.1
* ENHANCEMENT
    * get!, post!, put!, delete!
* BUGFIX
    * ensure the same interface sending header to app

## 0.1.0
* ENHANCEMENT
    * gurantee the same interface in error response

## 0.0.3
* ENHANCEMENT
    * creae :httpclient_json driver

## 0.0.2
* ENHANCEMENT
    * support capybara < 1.0

## 0.0.1
* ENHANCEMENT
    * create :rack_test_json driver
