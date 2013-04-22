require 'spec_helper'
require 'dhl-shipping/dhl-shipping'
require "dhl-shipping/errors"

describe DhlShipping do

  let(:valid_params) do
    {
      :site_id  => 'SomeId',
      :password => 'p4ssw0rd'
    }
  end

  subject do
    DhlShipping.new(valid_params)
  end

  describe ".new" do
    it "must return an instance of DhlShipping" do
      DhlShipping.new(valid_params).must be_an_instance_of(DhlShipping)
    end

    it "must throw an error if a site id is not passed" do
      lambda do
        DhlShipping.new(valid_params.merge(:site_id => nil))
      end.must raise_exception(DhlShipping::OptionsError)
    end

    it "must throw an error if a password is not passed" do
      lambda do
        DhlShipping.new(valid_params.merge(:password => nil))
      end.must raise_exception(DhlShipping::OptionsError)
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
      end.must raise_exception(DhlShipping::CountryCodeError)

      lambda do
        subject.from('D', '84111')
      end.must raise_exception(DhlShipping::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('us', '84111')
      end.must raise_exception(DhlShipping::CountryCodeError)
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
      end.must raise_exception(DhlShipping::CountryCodeError)

      lambda do
        subject.from('D', 'T1H 0A1')
      end.must raise_exception(DhlShipping::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('ca', 'T1H 0A1')
      end.must raise_exception(DhlShipping::CountryCodeError)
    end
  end

  describe "#dutiable?" do
    it "must be true if dutiable set to yes" do
      subject.instance_variable_set(:@is_dutiable, true)
      subject.dutiable?.must be_true
    end

    it "must be false if dutiable set to no" do
      subject.instance_variable_set(:@is_dutiable, false)
      subject.dutiable?.must be_false
    end

    it "must default to false" do
      subject.dutiable?.must be_false
    end
  end

  describe "#dutiable" do
    it "must set dutiable to true if passed a true value" do
      subject.dutiable(true)
      subject.dutiable?.must be_true
    end

    it "must set dutiable to false if passed a false value" do
      subject.dutiable(false)
      subject.dutiable?.must be_false
    end
  end

  describe "#dutiable!" do
    it "must set dutiable() to true" do
      subject.dutiable?.must be_false #sanity

      subject.dutiable!
      subject.dutiable?.must be_true
    end
  end

  describe "#not_dutiable!" do
    it "must set dutiable() to false" do
      subject.instance_variable_set(:@is_dutiable, true)
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

  describe "#centimeters!" do
    it "must set the dimensions_unit to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, nil)

      subject.centimeters!
      subject.dimensions_unit.must == "CM"
    end
  end

  describe "#inches!" do
    it "must set the dimensions_unit to inches" do
      subject.instance_variable_set(:@dimensions_unit, nil)

      subject.inches!
      subject.dimensions_unit.must == "IN"
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
    it "must set the weight unit to kilograms" do
      subject.instance_variable_set(:@weight_unit, nil)

      subject.kilograms!
      subject.weight_unit.must == "KG"
    end
  end

  describe "#pounds!" do
    it "must set the weight unit to pounds" do
      subject.instance_variable_set(:@weight_unit, nil)

      subject.pounds!
      subject.weight_unit.must == "LB"
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



end