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

        it "must set the class test_mode? to true" do
          klass.test_mode?.must be_true
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
          klass.test_mode?.must be_false
        end

        it "Dhl::GetQuote::Request must honor this test mode" do
          request = Dhl::GetQuote::Request.new(valid_request_options)
          request.test_mode?.must be_false
        end
      end

      describe ".site_id" do
        before(:each) { klass.configure { |c| c.site_id "SomethingHere" } }

        it "must set class site_id to passed string" do
          expect(
            klass.site_id
          ).to eq("SomethingHere")
        end

        it "Dhl::GetQuote::Request must honor this" do
          request = Dhl::GetQuote::Request.new(
            :password => 'xxx'
          )

          expect(
            request.instance_variable_get(:@site_id)
          ).to eq("SomethingHere")
        end
      end

      describe ".password" do
        before(:each) { klass.configure { |c| c.password "ppaasswwoorrdd" } }

        it "must set class password to passed string" do
          expect(klass.password.must).to eq("ppaasswwoorrdd")
        end

        it "Dhl::GetQuote::Request must honor this" do
          request = Dhl::GetQuote::Request.new(
            :site_id => 'ASiteId'
          )

          expect(request.instance_variable_get(:@password)).to eq("ppaasswwoorrdd")
        end
      end

      describe "kilograms!" do
        # silence deprication notices in tests
        before(:each) { klass.stub!(:puts) }

        it "must call #metric_measurements!" do
          klass.must_receive(:metric_measurements!)
          klass.kilograms!
        end
      end

      describe "pounds!" do
        # silence deprication notices in tests
        before(:each) { klass.stub!(:puts) }

        it "must call #us_measurements!" do
          klass.must_receive(:us_measurements!)
          klass.pounds!
        end
      end

      describe "centimeters!" do
        # silence deprication notices in tests
        before(:each) { klass.stub!(:puts) }

        it "must call #metric_measurements!" do
          klass.must_receive(:metric_measurements!)
          klass.centimeters!
        end
      end

      describe "inches!" do
        # silence deprication notices in tests
        before(:each) { klass.stub!(:puts) }

        it "must call #us_measurements!" do
          klass.must_receive(:us_measurements!)
          klass.inches!
        end
      end

      describe "us_measurements!" do
        before(:each) { klass.metric_measurements! }
        it "must set the weight and dimensions to LB and IN" do
          klass.us_measurements!
          expect(klass.dimensions_unit).to eq("IN")
          expect(klass.weight_unit).to eq("LB")
        end

        it "Dhl::GetQuote::Request must honor this" do
          klass.us_measurements!
          expect(valid_request.dimensions_unit).to eq("IN")
          expect(valid_request.weight_unit).to eq("LB")
        end
      end

      describe "metric_measurements!" do
        before(:each) { klass.us_measurements! }
        it "must set the weight and dimensions to KG and CM" do
          klass.metric_measurements!
          expect(klass.dimensions_unit).to eq("CM")
          expect(klass.weight_unit).to eq("KG")
        end

        it "Dhl::GetQuote::Request must honor this" do
          klass.metric_measurements!
          expect(valid_request.dimensions_unit).to eq("CM")
          expect(valid_request.weight_unit).to eq("KG")
        end
      end
    end
  end

end
