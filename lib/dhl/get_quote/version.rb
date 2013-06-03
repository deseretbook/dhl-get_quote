class Dhl
  class GetQuote
    VERSION = "0.5.0"

    PostInstallMessage = <<EOS

*** NOTE Dhl-GetQuote ***

This version introduces the following changes from 0.4.x:

* #inches!, #pounds!, #kilograms! and #centimeters have been depricated.
  Please use #us_measurements! or #metric_measurements.

* dutiable! now requires arguments (dutiable value and currency).

EOS
  end
end
