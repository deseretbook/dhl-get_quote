require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote::Request do

  let(:valid_params) do
    {
      :site_id  => 'SomeId',
      :password => 'p4ssw0rd'
    }
  end

  let(:klass) { Dhl::GetQuote::Request }

  subject do
    klass.new(valid_params)
  end

  describe ".new" do
    it "must return an instance of Dhl::GetQuote" do
      klass.new(valid_params).must be_an_instance_of(Dhl::GetQuote::Request)
    end

    it "must throw an error if a site id is not passed" do
      lambda do
        klass.new(valid_params.merge(:site_id => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end

    it "must throw an error if a password is not passed" do
      lambda do
        klass.new(valid_params.merge(:password => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end
  end

  describe '#from' do
    it 'requires a country code as and postal code as parameters' do
      subject.from('US', '84111')

      subject.from_country_code.must == 'US'
      subject.from_postal_code.must == '84111'
    end

    it 'converts postal codes to strings' do
      subject.from('US', 84111)

      subject.from_postal_code.must == '84111'
    end

    it 'must raise error if country code is not 2 letters long' do
      lambda do
        subject.from('DDF', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)

      lambda do
        subject.from('D', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('us', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must accept an optional city name' do
      subject.from('US', '84111', "Bountiful")
      subject.instance_variable_get(:@from_city_name).must == 'Bountiful'
    end
  end

  describe '#to' do
    it 'requires a country code as and postal code as parameters' do
      subject.to('CA', 'T1H 0A1')

      subject.to_country_code.must == 'CA'
      subject.to_postal_code.must == 'T1H 0A1'
    end

    it 'converts postal codes to strings' do
      subject.to('CA', 1111)

      subject.to_postal_code.must == '1111'
    end

    it 'must raise error if country code is not 2 letters long' do
      lambda do
        subject.from('DDF', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)

      lambda do
        subject.from('D', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('ca', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must accept an optional city name' do
      subject.to('US', '84111', "Bountiful")
      subject.instance_variable_get(:@to_city_name).must == 'Bountiful'
    end
  end

  describe "#dutiable?" do
    it "must be true if dutiable set to yes" do
      subject.dutiable!(1.0, 'USD')
      subject.dutiable?.must be_true
    end

    it "must be false if dutiable set to no" do
      subject.not_dutiable!
      subject.dutiable?.must be_false
    end

    it "must default to false" do
      subject.dutiable?.must be_false
    end
  end

  describe "#dutiable!" do
    it "must accept a value and currency code" do
      subject.dutiable?.must be_false #sanity

      subject.dutiable!(1.0, 'CAD')

      subject.dutiable?.must be_true

      subject.duty.must be_an_instance_of Hash
      subject.duty[:declared_currency].must == 'CAD'
      subject.duty[:declared_value].must == 1.0
    end

    it "must use USD as the default currency code" do
      subject.dutiable!(1.0)

      subject.duty[:declared_currency].must == 'USD'
    end

    it "must upcase and truncate currency codes" do
      subject.dutiable!(1.0, 'MxPe')

      subject.duty[:declared_currency].must == 'MXP'
    end

    it "must cast value to float" do
      subject.dutiable!(1)

      subject.duty[:declared_value].must == 1.0
    end
  end

  describe "#not_dutiable!" do
    it "must set dutiable() to false" do
      subject.instance_variable_set(:@duty, {})
      subject.dutiable?.must be_true #sanity

      subject.not_dutiable!
      subject.dutiable?.must be_false
    end
  end

  describe "#weight_unit" do
    it "must return the set weight unit" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.weight_unit.must == "LB"
    end

    it "must default to KG if not otherwise set" do
      subject.instance_variable_set(:@weight_unit, nil)
      subject.weight_unit.must == "KG"
    end
  end

  describe "#dimensions_unit" do
    it "must return the set weight unit" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.dimensions_unit.must == "IN"
    end

    it "must default to CM if not otherwise set" do
      subject.instance_variable_set(:@dimensions_unit, nil)
      subject.dimensions_unit.must == "CM"
    end
  end

  describe "#us_measurements!" do
    it "should set the measurement units to us" do
      subject.instance_variable_set(:@dimensions_unit, "CM")
      subject.instance_variable_set(:@weight_unit, "KG")

      subject.us_measurements!

      subject.dimensions_unit.must == "IN"
      subject.weight_unit.must == "LB"
    end
  end

  describe "#metric_measurements!" do
    it "must set the measurement units to metric" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.instance_variable_set(:@weight_unit, "LB")

      subject.metric_measurements!

      subject.dimensions_unit.must == "CM"
      subject.weight_unit.must == "KG"
    end
  end

  describe "#metric_measurements?" do
    it "must be true if measurements are in kg and cm" do
      subject.metric_measurements!

      subject.metric_measurements?.must be_true
    end

    it "must be false if measurements are not in kg and cm" do
      subject.us_measurements!

      subject.metric_measurements?.must be_false
    end
  end

  describe "#us_measurements?" do
    it "must be true if measurements are in ln and in" do
      subject.us_measurements!

      subject.us_measurements?.must be_true
    end

    it "must be false if measurements are not in lb and in" do
      subject.metric_measurements!

      subject.us_measurements?.must be_false
    end
  end

  describe "#centimeters!" do
    # silence deprication notices in tests
    before(:each) { subject.stub!(:puts) }

    it "must call #metric_measurements!" do
      subject.must_receive(:metric_measurements!)
      subject.centimeters!
    end
  end

  describe "#inches!" do
    # silence deprication notices in tests
    before(:each) { subject.stub!(:puts) }

    it "must call #us_measurements!" do
      subject.must_receive(:us_measurements!)
      subject.inches!
    end
  end

  describe "#inches?" do
    it "must be true if dimensions unit is set to inches" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.inches?.must be_true
    end

    it "must be false if dimensions unit is not set to inches" do
      subject.instance_variable_set(:@dimensions_unit, "CM")
      subject.inches?.must be_false
    end
  end

  describe "#centimeters?" do
    it "must be true if dimensions unit is set to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, "CM")
      subject.centimeters?.must be_true
    end

    it "must be false if dimensions unit is not set to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.centimeters?.must be_false
    end
  end

  describe "#kilograms!" do
    # silence deprication notices in tests
    before(:each) { subject.stub!(:puts) }

    it "must call #metric_measurements!" do
      subject.must_receive(:metric_measurements!)
      subject.kilograms!
    end
  end

  describe "#pounds!" do
    # silence deprication notices in tests
    before(:each) { subject.stub!(:puts) }

    it "must call #us_measurements!" do
      subject.must_receive(:us_measurements!)
      subject.pounds!
    end
  end

  describe "#kilograms?" do
    it "must be true if weight unit is set to kilograms" do
      subject.instance_variable_set(:@weight_unit, "KG")
      subject.kilograms?.must be_true
    end

    it "must be false if dimensions unit is not set to inches" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.kilograms?.must be_false
    end
  end

  describe "#pounds?" do
    it "must be true if weight unit is set to pounds" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.pounds?.must be_true
    end

    it "must be false if weight unit is not set to pounds" do
      subject.instance_variable_set(:@weight_unit, "KG")
      subject.pounds?.must be_false
    end
  end

  describe "#to_xml" do
    before(:each) do
      subject.from('US', 84010)
      subject.to('CA', 'T1H 0A1')

      Timecop.freeze(Time.local(2013, 5, 15, 10, 5, 0))
    end

    after(:each) do
      Timecop.return
    end

    let(:time) { Time.now }

    let(:mock_piece) do
      mock(:piece,
        :to_xml => [
          "<Piece>",
          "#{" "*20}<Height>20</Height>",
          "#{" "*20}<Depth>20</Depth>",
          "#{" "*20}<Width>20</Width>",
          "#{" "*20}<Weight>19</Weight>",
          "#{" "*16}</Piece>"
        ].join("\n"),
        :validate! => nil,
        :piece_id= => nil
      )
    end

    # gsub here removes leading whitespace which may be variable.
    let(:xml_output) { subject.to_xml.gsub(/^\s+/, '') }

    it "must validate the object" do
      subject.must_receive(:validate!)

      subject.to_xml
    end

    it "must return an XML version of the object including Pieces" do

      subject.pieces << mock_piece
      subject.stub(:validate!)

      correct_response = <<eos
<?xml version="1.0" encoding="UTF-8"?>
<p:DCTRequest xmlns:p="http://www.dhl.com" xmlns:p1="http://www.dhl.com/datatypes" xmlns:p2="http://www.dhl.com/DCTRequestdatatypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com DCT-req.xsd ">
<GetQuote>
<Request>
<ServiceHeader>
<SiteID>SomeId</SiteID>
<Password>p4ssw0rd</Password>
</ServiceHeader>
</Request>
<From>
<CountryCode>US</CountryCode>
<Postalcode>84010</Postalcode>
</From>
<BkgDetails>
<PaymentCountryCode>US</PaymentCountryCode>
<Date>#{time.strftime("%Y-%m-%d")}</Date>
<ReadyTime>#{subject.ready_time(time)}</ReadyTime>
<ReadyTimeGMTOffset>+00:00</ReadyTimeGMTOffset>
<DimensionUnit>#{subject.dimensions_unit}</DimensionUnit>
<WeightUnit>#{subject.weight_unit}</WeightUnit>
<Pieces>
<Piece>
<Height>20</Height>
<Depth>20</Depth>
<Width>20</Width>
<Weight>19</Weight>
</Piece>
</Pieces>
<IsDutiable>N</IsDutiable>
</BkgDetails>
<To>
<CountryCode>CA</CountryCode>
<Postalcode>T1H 0A1</Postalcode>
</To>
</GetQuote>
</p:DCTRequest>
eos
      xml_output.must == correct_response
    end

    context "one special service is specified" do

      before(:each) { subject.add_special_service("D") }

      it "must add SpecialServiceType tags to XML" do
        sst_xml = "<QtdShp>
      <QtdShpExChrg>
          <SpecialServiceType>D</SpecialServiceType>
      </QtdShpExChrg>
  </QtdShp>"
        xml_output.must =~ /#{(sst_xml.gsub(/^\s+/, ''))}/
      end
    end

    context "many special services are specified" do

      before(:each) do
        subject.add_special_service("D")
        subject.add_special_service("SA")
      end

      it "must add SpecialServiceType tags to XML" do
        sst_xml = <<eos
<QtdShp>
<QtdShpExChrg>
<SpecialServiceType>D</SpecialServiceType>
</QtdShpExChrg>
<QtdShpExChrg>
<SpecialServiceType>SA</SpecialServiceType>
</QtdShpExChrg>
</QtdShp>
eos
        xml_output.must =~ /#{(sst_xml.gsub(/^\s+/, ''))}/
      end
    end
  end

  describe "#post" do
    let(:mock_httparty_response) do
      mock(:httparty_response, :body => nil)
    end
    let(:mock_response_object) { mock(:response_object) }
    before(:each) do
      subject.stub(:to_xml).and_return('<xml></xml>')
      subject.stub!(:validate!)
      HTTParty.stub!(:post).and_return(
        mock(:httparty, :response => mock_httparty_response)
      )
      Dhl::GetQuote::Response.stub!(:new).and_return(mock_response_object)
      
      # to be unstubbed later
      subject.stub(:log_request_and_response_xml)
    end

    it "must post to server" do
      HTTParty.must_receive(:post).with(
        Dhl::GetQuote::Request::URLS[:production],
        {
          :body => '<xml></xml>',
          :headers => { 'Content-Type' => 'application/xml' }
        }
      )

      subject.post
    end

    it "must return a new Response object" do
      subject.post.must == mock_response_object
    end

    context "there is an exception" do
      
      let(:exception) do
        NoMethodError.new("undefined method `detect' for nil:NilClass")
      end

      before(:each) do
        Dhl::GetQuote::Response.stub(:new).and_raise(exception)
        Dhl::GetQuote.stub(:log) # silence log output for this test
      end

      it "must log the request and response if there is any exception" do
        subject.unstub(:log_request_and_response_xml)
        # expect(subject).to receive(
        #   :log_request_and_response_xml
        # ).exactly(:once)
        subject.should_receive(
          :log_request_and_response_xml
        ).exactly(:once)

        # unless wrapped in an expect, the exception is swallowed!
        expect(
          lambda { subject.post }
        ).to raise_exception
      end

      it "must re-raise any exceptions" do
        expect(
          lambda { subject.post }
        ).to raise_exception(
          exception
        )
      end

      context "validation error" do
        let(:exception) do
          Dhl::GetQuote::OptionsError.new(":password is a required option")
        end

        before(:each) do
          Dhl::GetQuote::Response.stub(:new).and_raise(exception)
          subject.unstub(:log_request_and_response_xml)
        end

        after(:each) do
          expect( lambda { subject.post } ).to raise_exception
        end

        it "should log with the correct log level of :verbose" do
          Dhl::GetQuote.set_log_level(Dhl::GetQuote::DEFAULT_LOG_LEVEL)

          subject.should_receive(:log_exception).with(
            exception, exception.log_level
          )
        end
      end

      context ":critical error" do
        before(:each) do
          subject.unstub(:log_request_and_response_xml)
        end

        after(:each) do
          expect( lambda { subject.post } ).to raise_exception
        end

        it "must log exception name" do  
          subject.should_receive(:log_exception).with(
            exception, :critical
          )
        end

        it "must log the request xml" do
          subject.instance_variable_set(:@to_xml, 'this is request')

          subject.should_receive(:log_request_xml).with(
            "this is request", :critical
          )
        end

        it "must log the a note if no request xml has been generated yet" do
          subject.should_receive(:log_request_xml).with(
            "<not generated at time of error>", :critical
          )
        end

        it "must log the response body" do
          mock_httparty_response.stub(:body).and_return(
            'this is the body'
          )

          subject.should_receive(:log_response_xml).with(
            "this is the body", :critical
          )
        end

        it "must log the a note if no response xml has been received yet" do
          subject.should_receive(:log_response_xml).with(
            "<not received at time of error>", :critical
          )
        end
      end
    end

  end

  describe "#add_special_service" do
    before(:each) { subject.special_services.must == [] }
    it "should accept a single string of the special service type code and add it to the list" do
      subject.add_special_service("D")
      subject.special_services.must == ["D"] #sanity
    end

    it "should not add the same service twice" do
      subject.add_special_service("SA")
      subject.add_special_service("SA")
      subject.special_services.must == ["SA"]
    end

    it "should not add anything if service type code passed is blank" do
      subject.add_special_service("")
      subject.special_services.must == []
    end
  end

  describe "#remove_special_service" do
    before(:each) do
      subject.instance_variable_set(:@special_services_list, Set.new(["D"]))
    end

    it "should accept a single string of the special service type code and remove it from the list" do
      subject.remove_special_service("D")
      subject.special_services.must == [] #sanity
    end

    it "should throw an error if service to be removed does not exist in list" do
      subject.remove_special_service("SA")
      subject.special_services.must == ["D"]
    end

    it "should not add anything if service type code passed is blank" do
      subject.remove_special_service("")
      subject.special_services.must == ["D"]
    end
  end

  describe "#special_services" do
    before(:each) do
      subject.instance_variable_set(:@special_services_list, Set.new(["D"]))
    end

    it "must return an array of the special service codes" do
      subject.special_services.must == ["D"]
    end
  end

  describe "#test_mode?" do
    it "must be false if not in test mode" do
      subject.instance_variable_set(:@test_mode, false)

      subject.test_mode?.must be_false
    end

    it "must be false if not in test mode" do
      subject.instance_variable_set(:@test_mode, true)

      subject.test_mode?.must be_true
    end
  end

  describe "#test_mode!" do
    it "must set test_mode to true" do
      subject.instance_variable_set(:@test_mode, false)

      subject.test_mode!
      subject.instance_variable_get(:@test_mode).must be_true
    end
  end

  describe "#production_mode!" do
    it "must set test_mode to false" do
      subject.instance_variable_set(:@test_mode, true)

      subject.production_mode!
      subject.instance_variable_get(:@test_mode).must be_false
    end
  end

  describe "#ready_time" do
    after(:each) do
      Timecop.return
    end

    it "should conver the current time into a DHL timestamp" do
      Timecop.freeze(Time.local(2013, 5, 15, 10, 5, 0))

      subject.ready_time.must == 'PT10H05M'
    end

    context "the time is after 5pm" do
      it "should provide a stamp for the 8am" do
        Timecop.freeze(Time.local(2013, 5, 15, 19, 5, 0))

        subject.ready_time.must == 'PT08H00M'
      end
    end

    context "the time is before 8am" do
      it "should provide a stamp for the 8am" do
        Timecop.freeze(Time.local(2013, 5, 15, 6, 5, 0))

        subject.ready_time.must == 'PT08H00M'
      end
    end
  end

  describe "#ready_date" do
    after(:each) do
      Timecop.return
    end

    it 'should provide an ISO date of the current or next business day' do
      Timecop.freeze(Time.local(2013, 5, 15, 10, 5, 0))

      subject.ready_date.must == '2013-05-15'
    end

    context 'the date is friday' do
      context 'the time is before 5pm' do
        it 'must return todays date' do
          Timecop.freeze(Time.local(2013, 5, 31, 10, 4, 0))

          subject.ready_date.must == '2013-05-31'
        end
      end
      context 'the time is after 5pm' do
        it 'must return next monday' do
          Timecop.freeze(Time.local(2013, 5, 31, 19, 4, 0))

          subject.ready_date.must == '2013-06-03'
        end
      end
    end

    context 'the date is saturday' do
      it "must return the next monday" do
        Timecop.freeze(Time.local(2013, 7, 6, 10, 4, 0))

        subject.ready_date.must == '2013-07-08'
      end
    end

    context 'the date is sunday' do
      it "must return the next monday" do
        Timecop.freeze(Time.local(2013, 7, 7, 10, 4, 0))

        subject.ready_date.must == '2013-07-08'
      end
    end
  end

  describe "#payment_account_number" do
    context "payment account number is passed" do
      it "must set the pac to be the passed number" do
        subject.payment_account_number('abc123')

        subject.instance_variable_get(:@payment_account_number).must == 'abc123'
      end
    end
    context "payment account number is not passes" do
      it "must be nil if no pac is recorded" do
        subject.payment_account_number.must be_nil
      end
      it "must return the pac if one was set previously" do
        subject.instance_variable_set(:@payment_account_number, '123abc')

        subject.payment_account_number.must == '123abc'
      end
    end
  end
end
