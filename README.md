[![Build Status](https://travis-ci.org/deseretbook/dhl-get_quote.png)](https://travis-ci.org/deseretbook/dhl-get_quote)

# Dhl::GetQuote

Get shipping quotes from DHL's XML-PI Service.

Use of the XML-PI Service requires you to have Site ID and Password from DHL. You can sign up here: https://myaccount.dhl.com/MyAccount/jsp/TermsAndConditionsIndex.htm

## Installation

Add this line to your application's Gemfile:

    gem 'dhl-get_quote'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhl-get_quote

## Basic Usage

```ruby
  require 'dhl-get_quote'

  r = Dhl::GetQuote::Request.new(
    :site_id => "SiteIdHere",
    :password => "p4ssw0rd",
    :test_mode => true # changes the url being hit
  )

  r.kilograms!
  r.centimeters!

  r.add_special_service("DD")

  r.to('CA', "T1H 0A1")
  r.from('US', 84010)

  r.pieces << Dhl::GetQuote::Piece.new(
    :height => 20,
    :weight => 20,
    :width => 20,
    :depth => 19
  )

  response = r.post
  if response.error?
    raise "There was an error: #{resp.raw_xml}"
  else
    puts "Your cost to ship will be: #{resp.total_amount} in #{resp.currency_code}."
  end
```

---

### Dhl::GetQuote::Request

#### Making a new request

This is where the magic starts. It accepts a hash that, at minimum, requires :site\_id and :password. Optionally, :test\_mode may be passed in to tell the gem to use the XML-PI test URL. The default is to *not* use test mode and to hit the production URL.

```ruby
request = Dhl::GetQuote::Request.new(
  :site_id => "SiteIdHere",
  :password => "p4ssw0rd",
  :test_mode => false
)
```

*NOTE*: You can also set default beforehand in, for example, an initializer. For more information on this, please see the section "Initializers with Dhl::GetQuote"

#### Package Source and Destination

To set the source and destination, use the #to() and #from() methods:

  #to(_country_code_, _postal_code_), #from(_country_code_, _postal_code_)

The country code must be the two-letter capitalized ISO country code. The postal code will be cast in to a string.

Example:

```ruby
  request.from('US', 84111)
  request.to('CA', 'T1H 0A1')
```

#### Measurement Units

DHL can accept weights and measures in both Metric and US Customary units.  Weights are given in either pounds or kilograms, dimensions in either inches or centimeters. This gem defaults to use metric measurements.

To set to US Customary, use:

```ruby
  request.inches! # set dimensions to inches
  request.pounds! # set weight to pounds
```

To set back to Metric, use

```ruby
  request.centimeters! # set dimensions to centimeters
  request.centimetres! # alternate spelling

  request.kilograms!   # set weight to kilograms
  request.kilogrammes! # alternate spelling
```

To query what measurement system the object is currently using, use the following boolean calls:

```ruby
  request.inches?
  request.centimeters? # or request.centimetres?

  request.pounds?
  request.kilograms? # or request.kilogrammes?
```

You can also get the value directly:

```ruby
  request.dimensions_unit # will return either "CM" or "IN"
  request.weight_unit     # will return either "KG" or "LB"
```

#### Setting Duty

! Note, this a breaking change from 0.4.x

To set the duty on a shipment, use the dutiable!() method. It accepts the numeric value and an optional currency code. If not specified, the currency code default to US Dollars (USD).

```ruby
  # set the dutiable value at $100 in US Dollars
  request.dutiable!(100.00, 'USD')
```

To remove a previously set duty, use the not_dutiable!() method.

```ruby
  request.not_dutiable!
```

You can query the current state with #dutiable?:

```ruby
  request.dutiable? # returns true or false
```

The default is for the request is "not dutiable".

#### Shipment Services

Shipment services (speed, features, etc) can be added, listed and removed.

To add a special service, call #add_special_service as pass in DHL-standard code for the service:

```ruby
  request.add_special_service("D")
```

To list all services currently added to a request, use #special_services:

```ruby
  request.special_services
```

To remove a special service, use #remove_special_service and pass the code:

```ruby
  request.remove_special_service("D")
```

The interface will not allow the same special service code to be added twice, it will be silently ignored if you try.


#### Adding items to the request

To add items to the shipping quote request, generate a new Dhl::GetQuote::Piece instance and append it to #pieces:

```ruby
  # minimal
  request.pieces << Dhl::GetQuote::Piece.new( :weight => 20 )

  # more details
  request.pieces << Dhl::GetQuote::Piece.new(
    :weight => 20, :height => 20, :width => 20, :depth => 19
  )
```

Dhl::GetQuote::Piece requires *at least* :weight to be specified, and it must be a nonzero integer.  Optionally, you can provide :width, :depth and :height. The measurement options must all be added at once and cannot be added individually. They must be integers.

#### Posting to DHL

Once the request is prepared, call #post() to post the request to the DHL XML-PI.  This will return a Dhl::GetQuote::Response object.

```ruby
  response = request.post
  response.class == Dhl::GetQuote::Response # true
```

---

### Dhl::GetQuote::Response

Once a post is sent to DHL, this gem will interpret the XML returned and create a Dhl::GetQuote::Response object.

#### Checking for errors

To check for errors in the response (both local and upstream), query the #error? and #error methods

```ruby
  response.error? # true
  response.error
  # => < Dhl::GetQuote::Upstream::ValidationFailureError: your site id is not correct blah blah >
```

#### Getting costs

The response object exposes the following values:

  * currency_code
  * currency_role_type_code
  * weight_charge
  * total_amount
  * total_tax_amount
  * weight_charge_tax

To find the total change:

```ruby
  puts "Your cost to ship will be: #{response.total_amount} in #{response.currency_code}."
  # Your cost to ship will be: 337.360 in USD.
```

DHL can return the cost in currency unit based on sender location or reciever location. It is unlikely this will be used much, but you can change the currency by calling #load_costs with the CurrencyRoleTypeCode:

```ruby
  response.load_costs('PULCL')
  puts "Your cost to ship will be: #{response.total_amount} in #{response.currency_code}."
  # Your cost to ship will be: 341.360 in CAD.
```

CurrencyRoleTypeCodes that can be used are:

  * BILLCU – Billing currency
  * PULCL – Country of pickup local currency
  * INVCU – Invoice currency
  * BASEC – Base currency

#### Accessing the raw response

If you need data from the response that is not exposed by this gem, you can access both the raw xml and parsed xml directly:

```ruby
  response.raw_xml    # raw xml string as returned by DHL
  response.parsed_xml # xml parsed in to a Hash for easy traversal
```

\#parsed\_xml() is not always available in the case of errors. #raw\_xml() is, except in cases of network transport errors.

#### Accessing offered services

In cases where you have either sent many special service code, or you are evaluating all available services (via the 'OSINFO' special service code), you can obtain a list of all the services with the #offered_services() and #all_services() methods. Both methods return an array of Dhl::GetQuote::MarketService objects.

The #offered_services() method returns only those services intended to be shown to the end user an optional services (XCH) they can apply. These would be services with either 'TransInd' or 'MrkSrvInd' set to 'Y'.

The #all_services() methods returns all associated services, including everything in #offered_services and also including possible fees (FEE) and surcharges (SCH).

If using 'OSINFO' to obtain all offered services, you pass the value of #code() in to Request#add_special_service() to apply this services to another request:

```ruby
  # assume we already did an 'OSINFO' request.
  new_request.add_special_service(response.offered_services.first.code)
```

---

### Dhl::GetQuote::MarketService

Instances of this object are returned from Response#offered_services() and Response#all_services().

#### Methods for parameters

All XML parameters in the response will be added as methods to this object.  They may vary but generally include:

* #local\_product\_code() - code for user-offered services (signature, tracking, overnight, etc)
* #local\_service_type() code for non-offered special services (fees, surcharges, etc)
* #local\_service\_type\_name() - Name for a non-offered service
* #local\_product\_name() - Name for a user-offered service
* #mrk\_srv\_ind() - Should this be offered to the user?
* #trans\_ind() - Should this be shown to every user regardless of shipping options?

#### Getting the code for a service

The #code() method will return the code for a given service. It will work on both non-offered and user-offered services, it queries both LocalProductCode and LocalServiceType.

```ruby
  market_service.code # "D"
```

This code can be passed in to Request#add_special_service()

#### Getting the name for a service

The #name() method will return the name for a given service. It will work on both non-offered and user-offered services, it queries both LocalProductName and LocalServiceTypeName.

```ruby
  market_service.name # "EXPRESS WORLDWIDE DOC"
```

---

### Initializers with Dhl::GetQuote

If you don't want to have to pass email, password, weight setting, etc, every time you build a new request object you can set these defaults beforehand. This works well in cases where you want to put setting in something like a Rails initializer.

To do this, call Dhl::GetQuote::configure and pass a block:

```ruby
  Dhl::GetQuote::configure do |c|

    c.side_id  "SomeSiteId"
    c.password "p4ssw0rd"

    c.production_mode! # or test_mode!

    c.kilograms!   # or kilogrammes!
    c.centimeters! # or centimetres!
    c.inches!
    c.pounds!

    c.dutiable! # or not_dutiable!

  end
```

The above block sets defaults for use thereafter. You would then not have to pass site\_id or password in to Dhl::GetQuote::new():

```ruby
  Dhl::GetQuote::configure do |c|
    c.side_id  "SomeSiteId"
    c.password "p4ssw0rd"
  end

  request = Dhl::GetQuote::new()
```

*Note*: options passed in to _Dhl::GetQuote::new()_ will override setting in the _Dhl::GetQuote::configure_ block.
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add tests, make sure existing tests pass.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
