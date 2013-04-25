require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote do

  # classvars may be remembered between tests, this sets things back to default
  after(:each) do
    Dhl::GetQuote.set_defaults
  end

  let(:klass) { Dhl::GetQuote }

  let(:valid_request_options) do
    {
      :site_id  => 'SiteId',
      :password => 'p4ssw0rd'
    }
  end

  let (:valid_request) { request = Dhl::GetQuote::Request.new(valid_request_options) }

  describe ".configure" do

    it "must accept and execute a block" do
      lambda do
        klass.configure do
          raise RuntimeError, "Testing"
        end
      end.must raise_exception RuntimeError
    end

    context "configure() block" do

      describe ".test_mode!" do
        before(:each) do
          klass.configure { |c| c.test_mode! }
        end

        it "must set the classvar test_mode to true" do
          klass.class_variable_get(:@@test_mode).must be_true
        end

        it "Dhl::GetQuote::Request must honor this test mode" do
          request = Dhl::GetQuote::Request.new(valid_request_options)
          request.test_mode?.must be_true
        end
      end

      describe ".production_mode!" do
        before(:each) do
          klass.configure { |c| c.production_mode! }
        end

        it "must set the classvar test_mode to false" do
          klass.class_variable_get(:@@test_mode).must be_false
        end

        it "Dhl::GetQuote::Request must honor this test mode" do
          request = Dhl::GetQuote::Request.new(valid_request_options)
          request.test_mode?.must be_false
        end
      end

      describe ".site_id" do
        before(:each) { klass.configure { |c| c.site_id "SomethingHere" } }

        it "must set class site_id to passed string" do
          klass.site_id.must == "SomethingHere"
        end

        it "Dhl::GetQuote::Request must honor this" do
          request = Dhl::GetQuote::Request.new(
            :password => 'xxx'
          )

          request.instance_variable_get(:@site_id).must == "SomethingHere"
        end
      end

      describe ".password" do
        before(:each) { klass.configure { |c| c.password "ppaasswwoorrdd" } }

        it "must set class password to passed string" do
          klass.password.must == "ppaasswwoorrdd"
        end

        it "Dhl::GetQuote::Request must honor this" do
          request = Dhl::GetQuote::Request.new(
            :site_id => 'ASiteId'
          )

          request.instance_variable_get(:@password).must == "ppaasswwoorrdd"
        end
      end

      describe "kilograms!" do
        before(:each) { klass.configure { |c| c.kilograms! } }

        it "must set class weight_unit to KG" do
          klass.weight_unit.must == "KG"
        end

        it "Dhl::GetQuote::Request must honor this" do
          valid_request.weight_unit.must == "KG"
        end
      end

      describe "pounds!" do
        before(:each) { klass.configure { |c| c.pounds! } }

        it "must set class weight_unit to LB" do
          klass.weight_unit.must == "LB"
        end

        it "Dhl::GetQuote::Request must honor this" do
          valid_request.weight_unit.must == "LB"
        end
      end

      describe "centimeters!" do
        before(:each) { klass.configure { |c| c.centimeters! } }

        it "must set class weight_unit to CM" do
          klass.dimensions_unit.must == "CM"
        end

        it "Dhl::GetQuote::Request must honor this" do
          valid_request.dimensions_unit.must == "CM"
        end
      end

      describe "inches!" do
        before(:each) { klass.configure { |c| c.inches! } }

        it "must set class weight_unit to IN" do
          klass.dimensions_unit.must == "IN"
        end

        it "Dhl::GetQuote::Request must honor this" do
          valid_request.dimensions_unit.must == "IN"
        end
      end

      describe ".dutiable!" do
        before(:each) do
          klass.configure { |c| c.dutiable! }
        end

        it "must set the class dutiable to true" do
          klass.dutiable?.must be_true
        end

        it "Dhl::GetQuote::Request must honor this test mode" do
          request = Dhl::GetQuote::Request.new(valid_request_options)
          request.dutiable?.must be_true
        end
      end

      describe ".not_dutiable!" do
        before(:each) do
          klass.configure { |c| c.not_dutiable! }
        end

        it "must set the classvar test_mode to false" do
          klass.dutiable?.must be_false
        end

        it "Dhl::GetQuote::Request must honor this test mode" do
          request = Dhl::GetQuote::Request.new(valid_request_options)
          request.dutiable?.must be_false
        end
      end

    end
  end

end
