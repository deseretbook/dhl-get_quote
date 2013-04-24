require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote::Response do

  let(:klass) { Dhl::GetQuote::Response }

  let(:valid_xml) { valid_dhl_response }
  let(:invalid_xml) { "<invalid></xml>" }

  subject do
    klass.new(valid_xml)
  end

  describe "#initialize" do

    it "must return a Dhl::GetQuote::Response object" do
      subject.must be_an_instance_of(klass)
    end

    context "valid xml" do

      let(:r) { klass.new(valid_xml) }

      it "must return a valid object" do
        r.must be_an_instance_of(klass)
      end

      it "must not indicate an error" do
        r.error?.must be_false
      end

      it "must expose the parsed XML" do
        r.parsed_xml.must be_an_instance_of Hash
      end

      it "must preserve the original XML" do
        r.raw_xml.must == valid_xml
      end

    end

    context "invalid xml" do

      let(:r) { klass.new(invalid_xml) }

      it "must return a valid object" do
        r.must be_an_instance_of(klass)
      end

      it "must indicate an error" do
        r.error?.must be_true
      end

      it "must expose the root xml error" do
        r.error.must be_an_instance_of MultiXml::ParseError
      end

      it "must preserve the original XML" do
        r.raw_xml.must == invalid_xml
      end

    end

    context "invalid site id" do
      let(:r) { klass.new(incorrect_site_id_response) }

      it "must return a valid object" do
        r.must be_an_instance_of(klass)
      end

      it "must indicate an error" do
        r.error?.must be_true
      end

      it "must set the error value appropriately" do
        r.error.must be_an_instance_of Dhl::GetQuote::Upstream::ValidationFailureError
      end

    end

    context "invalid password" do
      let(:r) { klass.new(incorrect_password_response) }

      it "must return a valid object" do
        r.must be_an_instance_of(klass)
      end

      it "must indicate an error" do
        r.error?.must be_true
      end

      it "must set the error value appropriately" do
        r.error.must be_an_instance_of Dhl::GetQuote::Upstream::ValidationFailureError
      end

    end

  end

  describe "#error?" do
    it "must be true if there is an error present" do
      subject.instance_variable_set(:@error, mock(:error))

      subject.error?.must be_true
    end

    it "must be false if there is no error present" do
      subject.instance_variable_set(:@error, nil)

      subject.error?.must be_false
    end
  end

  describe "#load_costs" do
    it "must load the costs with the associated currency_role_type_code" do
      subject.load_costs("BILLC")

      # references values from spec_helper#valid_dhl_response
      subject.currency_code.must == 'USD'
      subject.currency_role_type_code.must == 'BILLC'
      subject.weight_charge.must == "253.550"
      subject.total_amount.must == "283.980"
      subject.total_tax_amount == "0.000"
      subject.weight_charge_tax == "0.000"
    end
  end

  describe "#offered_services" do

    subject { klass.new(mkt_srv_response) }

    it "must return a list of only offered services (MrkSrvInd=Y or TransInd=Y) as MarketService objects" do
      subject.offered_services.map(&:code).must == %w[ AB D GG II QA SA TA ]
    end
  end

  describe "#all_services" do

    subject { klass.new(mkt_srv_response) }

    it "must return a list of all services regardless of offer type (MrkSrvInd = N/Y) as MarketService objects" do
      subject.all_services.map(&:code).must == %w[ AB AD D FF GG II JA OB OO PA PC PX QA SA TA ]
    end
  end
end
