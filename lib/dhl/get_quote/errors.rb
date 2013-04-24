class Dhl::GetQuote
  class InputError < StandardError; end
  class OptionsError < InputError; end
  class FromNotSetError < InputError; end
  class ToNotSetError < InputError; end
  class CountryCodeError < InputError; end
  class PieceError < InputError; end

  class Upstream < StandardError
    class UnknownError < Upstream; end
    class ValidationFailureError < Upstream; end
  end
end