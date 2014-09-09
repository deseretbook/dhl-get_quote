class Dhl
  class GetQuote
    VERSION = "0.5.5"

    PostInstallMessage = <<EOS

*** NOTE Dhl-GetQuote ***

This version introduces the following changes from 0.5.3:

* Logging of request and response in the event of an error
* Logging levels and logging method can be set

This version introduces the following changes from 0.4.x:

* #inches!, #pounds!, #kilograms! and #centimeters have been depricated.
  Please use #us_measurements! or #metric_measurements!.

* dutiable() replaces dutiable! now requires arguments (dutiable value and currency).

This version introduces the following changes from 0.5.1:

* Product.new() can accept weights and measures as float as well as by integer.

EOS
  end
end
