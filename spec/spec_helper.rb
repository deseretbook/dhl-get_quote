require 'rspec'
require 'rspec/must'
require 'webmock/rspec'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end

def valid_dhl_response
  '<?xml version="1.0" encoding="UTF-8"?>
<res:DCTResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com DCT-Response.xsd">
  <GetQuoteResponse>
    <Response>
      <ServiceHeader>
        <MessageTime>2013-04-23T01:12:14.907+01:00</MessageTime>
        <SiteID>SomeSiteId</SiteID>
      </ServiceHeader>
    </Response>
    <BkgDetails>
      <OriginServiceArea>
        <FacilityCode>SLC</FacilityCode>
        <ServiceAreaCode>SLC</ServiceAreaCode>
      </OriginServiceArea>
      <DestinationServiceArea>
        <FacilityCode>YQL</FacilityCode>
        <ServiceAreaCode>YYC</ServiceAreaCode>
      </DestinationServiceArea>
      <QtdShp>
        <GlobalProductCode>D</GlobalProductCode>
        <LocalProductCode>D</LocalProductCode>
        <ProductShortName>EXPRESS WORLDWIDE</ProductShortName>
        <LocalProductName>EXPRESS WORLDWIDE DOC</LocalProductName>
        <NetworkTypeCode>TD</NetworkTypeCode>
        <POfferedCustAgreement>N</POfferedCustAgreement>
        <TransInd>Y</TransInd>
        <PickupDate>2013-04-22</PickupDate>
        <PickupCutoffTime>PT17H</PickupCutoffTime>
        <BookingTime>PT16H</BookingTime>
        <CurrencyCode>USD</CurrencyCode>
        <ExchangeRate>1.000000</ExchangeRate>
        <WeightCharge>253.550</WeightCharge>
        <WeightChargeTax>0.000</WeightChargeTax>
        <TotalTransitDays>2</TotalTransitDays>
        <PickupPostalLocAddDays>0</PickupPostalLocAddDays>
        <DeliveryPostalLocAddDays>1</DeliveryPostalLocAddDays>
        <PickupNonDHLCourierCode/>
        <DeliveryNonDHLCourierCode/>
        <DeliveryDate>2013-04-24</DeliveryDate>
        <DeliveryTime>PT23H59M</DeliveryTime>
        <DimensionalWeight>41.888</DimensionalWeight>
        <WeightUnit>LB</WeightUnit>
        <PickupDayOfWeekNum>1</PickupDayOfWeekNum>
        <DestinationDayOfWeekNum>3</DestinationDayOfWeekNum>
        <QtdShpExChrg>
          <SpecialServiceType>FF</SpecialServiceType>
          <LocalServiceType>FF</LocalServiceType>
          <GlobalServiceName>FUEL SURCHARGE</GlobalServiceName>
          <LocalServiceTypeName>FUEL SURCHARGE</LocalServiceTypeName>
          <ChargeCodeType>SCH</ChargeCodeType>
          <CurrencyCode>USD</CurrencyCode>
          <ChargeValue>30.430</ChargeValue>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>30.430</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>BILLC</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>30.430</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>PULCL</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>30.430</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>BASEC</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
        </QtdShpExChrg>
        <PricingDate>2013-04-23</PricingDate>
        <ShippingCharge>283.980</ShippingCharge>
        <TotalTaxAmount>0.000</TotalTaxAmount>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>BILLC</CurrencyRoleTypeCode>
          <WeightCharge>253.550</WeightCharge>
          <TotalAmount>283.980</TotalAmount>
          <TotalTaxAmount>0.000</TotalTaxAmount>
          <WeightChargeTax>0.000</WeightChargeTax>
        </QtdSInAdCur>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>PULCL</CurrencyRoleTypeCode>
          <WeightCharge>253.550</WeightCharge>
          <TotalAmount>283.980</TotalAmount>
          <TotalTaxAmount>0.000</TotalTaxAmount>
          <WeightChargeTax>0.000</WeightChargeTax>
        </QtdSInAdCur>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>BASEC</CurrencyRoleTypeCode>
          <WeightCharge>253.550</WeightCharge>
          <TotalAmount>283.980</TotalAmount>
          <TotalTaxAmount>0.000</TotalTaxAmount>
          <WeightChargeTax>0.000</WeightChargeTax>
        </QtdSInAdCur>
      </QtdShp>
    </BkgDetails>
    <Srvs>
      <Srv>
        <GlobalProductCode>D</GlobalProductCode>
        <MrkSrv>
          <LocalProductCode>D</LocalProductCode>
          <ProductShortName>EXPRESS WORLDWIDE</ProductShortName>
          <LocalProductName>EXPRESS WORLDWIDE DOC</LocalProductName>
          <NetworkTypeCode>TD</NetworkTypeCode>
          <POfferedCustAgreement>N</POfferedCustAgreement>
          <TransInd>Y</TransInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>FF</LocalServiceType>
          <GlobalServiceName>FUEL SURCHARGE</GlobalServiceName>
          <LocalServiceTypeName>FUEL SURCHARGE</LocalServiceTypeName>
          <ChargeCodeType>SCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
      </Srv>
    </Srvs>
  </GetQuoteResponse>
</res:DCTResponse>'
end

def incorrect_site_id_response
  '<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">
    <Response>
        <ServiceHeader>
            <MessageTime>2013-04-23T21:59:57+01:00</MessageTime>
            <SiteID>SomeSiteId</SiteID>
            <Password>SomeSiteId</Password>
        </ServiceHeader>
        <Status>
            <ActionStatus>Error</ActionStatus>
            <Condition>
                <ConditionCode>100</ConditionCode>
                <ConditionData>Validation Failure:Site Id is wrong</ConditionData>
            </Condition>
        </Status>
    </Response></res:ErrorResponse>'
end

def incorrect_password_response
  '<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">
    <Response>
        <ServiceHeader>
            <MessageTime>2013-04-23T22:01:55+01:00</MessageTime>
            <SiteID>SomeSiteId</SiteID>
            <Password>SomeSiteId</Password>
        </ServiceHeader>
        <Status>
            <ActionStatus>Error</ActionStatus>
            <Condition>
                <ConditionCode>100</ConditionCode>
                <ConditionData>Validation Failure:Password provided is wrong</ConditionData>
            </Condition>
        </Status>
    </Response></res:ErrorResponse>'
end