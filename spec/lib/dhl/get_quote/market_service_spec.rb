require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote::MarketService do

  let(:valid_params) do
    {
      :local_service_type => "SA",
      :global_service_name => "DELIVERY SIGNATURE",
      :local_service_type_name => "DELIVERY SIGNATURE",
      :s_offered_cust_agreement => "N",
      :charge_code_type => "XCH",
      :mrk_srv_ind => "Y"
    }
  end

  let(:valid_xml) do
    '<MrkSrv>
  <LocalServiceType>SA</LocalServiceType>
  <GlobalServiceName>DELIVERY SIGNATURE</GlobalServiceName>
  <LocalServiceTypeName>DELIVERY SIGNATURE</LocalServiceTypeName>
  <SOfferedCustAgreement>N</SOfferedCustAgreement>
  <ChargeCodeType>XCH</ChargeCodeType>
  <MrkSrvInd>Y</MrkSrvInd>
</MrkSrv>'
  end

  let(:klass) { Dhl::GetQuote::MarketService }

  subject do
    klass.new(valid_params)
  end

  describe "#initialize" do

    context "string of xml is passed" do

      it 'must build object from xml data' do

        m = klass.new(valid_xml)

        m.local_service_type.must == "SA"
        m.global_service_name.must == "DELIVERY SIGNATURE"
        m.local_service_type_name.must == "DELIVERY SIGNATURE"
        m.s_offered_cust_agreement.must == "N"
        m.charge_code_type.must == "XCH"
        m.mrk_srv_ind.must == "Y"

      end
    end

    context "hash is passed" do

      it "must build an object from the hash" do

        m = klass.new(valid_params)

        valid_params.each do |k,v|
          m.send(k).must == v
        end

      end

    end
  end

  describe "#code" do
    it "must return the special service code for a mrksrv" do
      subject.code.must == "SA"
    end
  end

  describe "#name" do
    it "must return the local name for a mrksrv" do
      subject.name.must == "DELIVERY SIGNATURE"
    end
  end
end