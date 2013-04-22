require 'rubygems'
require 'httparty'
class DhlShipping
  attr_reader :from_country_code, :from_postal_code, :to_country_code, :to_postal_code

  DIMENSIONS_UNIT_CODES = { :centimeters => "CM", :inches => "IN" }
  WEIGHT_UNIT_CODES = { :kilograms => "KG", :pounds => "LB" }

  def initialize(options={})
    raise OptionsError, ":site_id is a required option" unless options[:site_id]
    raise OptionsError, ":password is a required option" unless options[:password]
  end

  def from(country_code, postal_code)
    @from_postal_code = postal_code.to_s
    validate_country_code!(country_code)
    @from_country_code = country_code
  end

  def to(country_code, postal_code)
    @to_postal_code = postal_code.to_s
    validate_country_code!(country_code)
    @to_country_code = country_code
  end

  def dutiable?
    !!@is_dutiable
  end

  def dutiable(val)
    @is_dutiable = !!val
  end

  def dutiable!
    dutiable(true)
  end

  def not_dutiable!
    dutiable(false)
  end

  def dimensions_unit
    @dimensions_unit ||= DIMENSIONS_UNIT_CODES[:centimeters]
  end

  def weight_unit
    @weight_unit ||= WEIGHT_UNIT_CODES[:kilograms]
  end

  def centimeters!
    @dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
  end
  alias :centimetres! :centimeters!

  def inches!
    @dimensions_unit = DIMENSIONS_UNIT_CODES[:inches]
  end

  def centimeters?
    dimensions_unit == DIMENSIONS_UNIT_CODES[:centimeters]
  end
  alias :centimetres? :centimeters?

  def inches?
    dimensions_unit == DIMENSIONS_UNIT_CODES[:inches]
  end

  def kilograms!
    @weight_unit = WEIGHT_UNIT_CODES[:kilograms]
  end
  alias :kilogrammes! :kilograms!

  def pounds!
    @weight_unit = WEIGHT_UNIT_CODES[:pounds]
  end

  def pounds?
    weight_unit == WEIGHT_UNIT_CODES[:pounds]
  end

  def kilograms?
    weight_unit == WEIGHT_UNIT_CODES[:kilograms]
  end
  alias :kilogrammes? :kilograms?

protected

  def validate_country_code!(country_code)
    unless country_code =~ /^[A-Z]{2}$/
      raise CountryCodeError, 'country code must be upper-case, two letters (A-Z)'
    end
  end
end