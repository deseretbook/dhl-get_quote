require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class Dhl::GetQuote::Request
  attr_reader :site_id, :password, :from_country_code, :from_postal_code, :to_country_code, :to_postal_code, :duty
  attr_accessor :pieces

  URLS = {
    :production => 'https://xmlpi-ea.dhl.com/XMLShippingServlet',
    :test       => 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
  }

  def initialize(options = {})
    @test_mode = !!options[:test_mode] || Dhl::GetQuote.test_mode?

    @site_id = options[:site_id] || Dhl::GetQuote.site_id
    @password = options[:password] || Dhl::GetQuote.password

    [ :site_id, :password ].each do |req|
      unless instance_variable_get("@#{req}").to_s.size > 0
        raise Dhl::GetQuote::OptionsError, ":#{req} is a required option"
      end
    end

    @special_services_list = Set.new

    @duty = false

    @pieces = []
  end

  def test_mode?
    !!@test_mode
  end

  def test_mode!
    @test_mode = true
  end

  def production_mode!
    @test_mode = false
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
    !!@duty
  end

  def dutiable!(value, currency_code="USD")
    @duty = {
      :declared_value => value.to_f,
      :declared_currency => currency_code.slice(0,3).upcase
    }
  end
  alias_method :dutiable, :dutiable!

  def not_dutiable!
    @duty = false
  end

  def dimensions_unit
    @dimensions_unit ||= Dhl::GetQuote.dimensions_unit
  end

  def weight_unit
    @weight_unit ||= Dhl::GetQuote.weight_unit
  end

  def centimeters!
    @dimensions_unit = Dhl::GetQuote::DIMENSIONS_UNIT_CODES[:centimeters]
  end
  alias :centimetres! :centimeters!

  def inches!
    @dimensions_unit = Dhl::GetQuote::DIMENSIONS_UNIT_CODES[:inches]
  end

  def centimeters?
    dimensions_unit == Dhl::GetQuote::DIMENSIONS_UNIT_CODES[:centimeters]
  end
  alias :centimetres? :centimeters?

  def inches?
    dimensions_unit == Dhl::GetQuote::DIMENSIONS_UNIT_CODES[:inches]
  end

  def kilograms!
    @weight_unit = Dhl::GetQuote::WEIGHT_UNIT_CODES[:kilograms]
  end
  alias :kilogrammes! :kilograms!

  def pounds!
    @weight_unit = Dhl::GetQuote::WEIGHT_UNIT_CODES[:pounds]
  end

  def pounds?
    weight_unit == Dhl::GetQuote::WEIGHT_UNIT_CODES[:pounds]
  end

  def kilograms?
    weight_unit == Dhl::GetQuote::WEIGHT_UNIT_CODES[:kilograms]
  end
  alias :kilogrammes? :kilograms?

  def to_xml
    validate!
    ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
  end

  # ready times are only 8a-5p(17h)
  def ready_time(time=Time.now)
    if time.hour >= 17 || time.hour < 8
      time.strftime("PT08H00M")
    else
      time.strftime("PT%HH%MM")
    end
  end

  # ready dates are only mon-fri
  def ready_date(t=Time.now)
    date = Date.parse(t.to_s)
    if date.wday >= 5 && t.hour >= 17
      date.send(:next_day, (8-date.wday))
    else
      date
    end.strftime("%Y-%m-%d")
  end

  def post
    validate!
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response

    Dhl::GetQuote::Response.new(response.body)
  end

  def special_services
    @special_services_list.to_a.sort
  end

  def add_special_service(special_service_type)
    return if special_service_type.to_s.size < 1
    @special_services_list << special_service_type
  end

  def remove_special_service(special_service_type)
    return if special_service_type.to_s.size < 1
    @special_services_list.delete_if{|x| x == special_service_type}
  end

protected

  def servlet_url
    test_mode? ? URLS[:test] : URLS[:production]
  end

  def validate!
    raise Dhl::GetQuote::FromNotSetError, "#from() is not set" unless (@from_country_code && @from_postal_code)
    raise Dhl::GetQuote::ToNotSetError, "#to() is not set" unless (@to_country_code && @to_postal_code)
    validate_pieces!
  end

  def validate_pieces!
    pieces.each do |piece|
      klass_name = "Dhl::GetQuote::Piece"
      if piece.class.to_s != klass_name
        raise Dhl::GetQuote::PieceError, "entry in #pieces is not a #{klass_name} object!"
      end
    end
  end

  def validate_country_code!(country_code)
    unless country_code =~ /^[A-Z]{2}$/
      raise Dhl::GetQuote::CountryCodeError, 'country code must be upper-case, two letters (A-Z)'
    end
  end

  def xml_template_path
    spec = Gem::Specification.find_by_name("dhl-get_quote")
    gem_root = spec.gem_dir
    gem_root + "/tpl/request.xml.erb"
  end
end
