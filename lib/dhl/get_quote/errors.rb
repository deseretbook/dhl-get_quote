class Dhl::GetQuote
  class InputError < StandardError
    def log_level; :verbose; end # by default we won't log these
  end
  class OptionsError < InputError; end
  class FromNotSetError < InputError; end
  class ToNotSetError < InputError; end
  class CountryCodeError < InputError; end
  class PieceError < InputError; end

  class Upstream < StandardError
    def log_level; :critical; end # by default we will log these
    class UnknownError < Upstream; end
    class ValidationFailureError < Upstream; end
    class ConditionError < Upstream
      attr_reader :code, :message
      def initialize(code, message)
        @code = code
        @message = message
      end

      def to_s
        "#{code}: #{message}"
      end
    end
  end
end