[![Build Status](https://travis-ci.org/deseretbook/dhl-get_quote.png)](https://travis-ci.org/deseretbook/dhl-get_quote)

# Dhl::GetQuote

Get shipping quotes from DHL's XML-PI Service.

Use of the XML-PI Service required you to have Site ID and Password issued to you from DHL. You can sign up for one here: https://myaccount.dhl.com/MyAccount/jsp/TermsAndConditionsIndex.htm

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

  resp = r.post
  if response.error?
    raise "There was an error: #{resp.raw_xml}"
  else
    puts "Your cost to ship will be: #{resp.total_amount} in #{resp.currency_code}."
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add tests, make sure existing tests pass.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
