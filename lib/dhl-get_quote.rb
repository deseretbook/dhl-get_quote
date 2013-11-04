require 'date'

require "dhl/get_quote/version"
require "dhl/get_quote/helper"
require "dhl/get_quote/errors"
require "dhl/get_quote/request"
require "dhl/get_quote/response"
require "dhl/get_quote/piece"
require "dhl/get_quote/market_service"

class Dhl
  class GetQuote

    DIMENSIONS_UNIT_CODES = { :centimeters => "CM", :inches => "IN" }
    WEIGHT_UNIT_CODES = { :kilograms => "KG", :pounds => "LB" }
    LOG_LEVELS = [:info, :critical, :debug, :none]
    DEFAULT_LOG_LEVEL = :info

    def self.configure(&block)
      yield self if block_given?
    end

    def self.test_mode!
      @@test_mode = true
    end

    def self.test_mode?
      !!@@test_mode
    end

    def self.production_mode!
      @@test_mode = false
    end

    def self.site_id(site_id=nil)
      if (s = site_id.to_s).size > 0
        @@site_id = s
      else
        @@site_id
      end
    end

    def self.password(password=nil)
      if (s = password.to_s).size > 0
        @@password = s
      else
        @@password
      end
    end

    def self.metric_measurements!
      @@weight_unit = WEIGHT_UNIT_CODES[:kilograms]
      @@dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
    end

    def self.us_measurements!
      @@weight_unit = WEIGHT_UNIT_CODES[:pounds]
      @@dimensions_unit = DIMENSIONS_UNIT_CODES[:inches]
    end

    def self.kilograms!
      deprication_notice(:kilograms!, :metric)
      metric_measurements!
    end
    def self.kilogrammes!; self.kilograms!; end

    def self.pounds!
      deprication_notice(:pounds!, :us)
      us_measurements!
    end

    def self.weight_unit
      @@weight_unit
    end

    def self.centimeters!
      deprication_notice(:centimeters!, :metric)
      metric_measurements!
    end
    def self.centimetres!; self.centimeters!; end

    def self.inches!
      deprication_notice(:inches!, :us)
      us_measurements!
    end

    def self.dimensions_unit
      @@dimensions_unit
    end

    def self.set_defaults
      @@site_id = nil
      @@password = nil
      @@weight_unit = WEIGHT_UNIT_CODES[:kilograms]
      @@dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
      @@dutiable = false
      @@test_mode = false

      @@logger = self.default_logger
      @@log_level = DEFAULT_LOG_LEVEL
    end

    def self.log(message, level = DEFAULT_LOG_LEVEL)
      validate_log_level!(level)
      return unless LOG_LEVELS.index(level.to_sym) >= LOG_LEVELS.index(log_level)
      get_logger.call(message)
    end

    def self.set_logger(logger_proc=nil, &block)
      @@logger = block || logger_proc || default_logger
    end

    def self.get_logger
      @@logger
    end

    def self.set_log_level(log_level)
      validate_log_level!(log_level)
      @@log_level = log_level
    end

    def self.log_level
      @@log_level
    end

    private

    def self.validate_log_level!(level)
      raise "Log level :#{level} is not valid" unless
        valid_log_level?(level)
    end

    def self.valid_log_level?(level)
      LOG_LEVELS.include?(level.to_sym)
    end

    def self.default_logger
      Proc.new do |message|
        STDERR.puts "Dhl-get_quote gem: #{message}"
      end
    end

    def self.deprication_notice(meth, m)
      messages = {
        :metric => "Method replaced by Dhl::GetQuote#metic_measurements!(). I am now setting your measurements to metric",
        :us     => "Method replaced by Dhl::GetQuote#us_measurements!(). I am now setting your measurements to US customary",
      }
      puts "!!!! Method \"##{meth}()\" is depricated. #{messages[m.to_sym]}."
    end
  end
end

Dhl::GetQuote.set_defaults