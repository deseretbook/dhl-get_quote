require 'rspec'
require 'rspec/must'

require 'timecop'

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

def mkt_srv_response
  '<?xml version="1.0" encoding="UTF-8"?>
<res:DCTResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com DCT-Response.xsd">
  <GetQuoteResponse>
    <Response>
      <ServiceHeader>
        <MessageTime>2013-04-24T18:21:48.522+01:00</MessageTime>
        <SiteID>Desere</SiteID>
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
        <PickupDate>2013-04-24</PickupDate>
        <PickupCutoffTime>PT17H</PickupCutoffTime>
        <BookingTime>PT16H</BookingTime>
        <CurrencyCode>USD</CurrencyCode>
        <ExchangeRate>1.000000</ExchangeRate>
        <WeightCharge>266.510</WeightCharge>
        <WeightChargeTax>0.000</WeightChargeTax>
        <TotalTransitDays>2</TotalTransitDays>
        <PickupPostalLocAddDays>0</PickupPostalLocAddDays>
        <DeliveryPostalLocAddDays>1</DeliveryPostalLocAddDays>
        <PickupNonDHLCourierCode/>
        <DeliveryNonDHLCourierCode/>
        <DeliveryDate>2013-04-26</DeliveryDate>
        <DeliveryTime>PT23H59M</DeliveryTime>
        <DimensionalWeight>44.092</DimensionalWeight>
        <WeightUnit>LB</WeightUnit>
        <PickupDayOfWeekNum>3</PickupDayOfWeekNum>
        <DestinationDayOfWeekNum>5</DestinationDayOfWeekNum>
        <QtdShpExChrg>
          <SpecialServiceType>FF</SpecialServiceType>
          <LocalServiceType>FF</LocalServiceType>
          <GlobalServiceName>FUEL SURCHARGE</GlobalServiceName>
          <LocalServiceTypeName>FUEL SURCHARGE</LocalServiceTypeName>
          <ChargeCodeType>SCH</ChargeCodeType>
          <CurrencyCode>USD</CurrencyCode>
          <ChargeValue>31.980</ChargeValue>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>31.980</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>BILLC</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>31.980</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>PULCL</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
          <QtdSExtrChrgInAdCur>
            <ChargeValue>31.980</ChargeValue>
            <CurrencyCode>USD</CurrencyCode>
            <CurrencyRoleTypeCode>BASEC</CurrencyRoleTypeCode>
          </QtdSExtrChrgInAdCur>
        </QtdShpExChrg>
        <PricingDate>2013-04-24</PricingDate>
        <ShippingCharge>298.490</ShippingCharge>
        <TotalTaxAmount>0.000</TotalTaxAmount>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>BILLC</CurrencyRoleTypeCode>
          <WeightCharge>266.510</WeightCharge>
          <TotalAmount>298.490</TotalAmount>
          <TotalTaxAmount>0.000</TotalTaxAmount>
          <WeightChargeTax>0.000</WeightChargeTax>
        </QtdSInAdCur>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>PULCL</CurrencyRoleTypeCode>
          <WeightCharge>266.510</WeightCharge>
          <TotalAmount>298.490</TotalAmount>
          <TotalTaxAmount>0.000</TotalTaxAmount>
          <WeightChargeTax>0.000</WeightChargeTax>
        </QtdSInAdCur>
        <QtdSInAdCur>
          <CurrencyCode>USD</CurrencyCode>
          <CurrencyRoleTypeCode>BASEC</CurrencyRoleTypeCode>
          <WeightCharge>266.510</WeightCharge>
          <TotalAmount>298.490</TotalAmount>
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
        <MrkSrv>
          <LocalServiceType>AB</LocalServiceType>
          <GlobalServiceName>SATURDAY PICKUP</GlobalServiceName>
          <LocalServiceTypeName>SATURDAY PICKUP</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>AD</LocalServiceType>
          <GlobalServiceName>HOLIDAY PICKUP</GlobalServiceName>
          <LocalServiceTypeName>HOLIDAY PICKUP</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>GG</LocalServiceType>
          <GlobalServiceName>PACKAGING</GlobalServiceName>
          <LocalServiceTypeName>PACKAGING</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>II</LocalServiceType>
          <GlobalServiceName>SHIPMENT INSURANCE</GlobalServiceName>
          <LocalServiceTypeName>SHIPMENT VALUE PROTECTION</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>JA</LocalServiceType>
          <GlobalServiceName>DELIVERY NOTIFICATION</GlobalServiceName>
          <LocalServiceTypeName>DELIVERY NOTIFICATION</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>OB</LocalServiceType>
          <GlobalServiceName>REMOTE AREA PICKUP</GlobalServiceName>
          <LocalServiceTypeName>REMOTE AREA PICKUP</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>SCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>OO</LocalServiceType>
          <GlobalServiceName>REMOTE AREA DELIVERY</GlobalServiceName>
          <LocalServiceTypeName>REMOTE AREA DELIVERY</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>SCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>PA</LocalServiceType>
          <GlobalServiceName>SHIPMENT PREPARATION</GlobalServiceName>
          <LocalServiceTypeName>SHIPMENT PREPARATION</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>PC</LocalServiceType>
          <GlobalServiceName>SHIPMENT CONSOLIDATION</GlobalServiceName>
          <LocalServiceTypeName>SHIPMENT CONSOLIDATION</LocalServiceTypeName>
          <SOfferedCustAgreement>Y</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>PX</LocalServiceType>
          <GlobalServiceName>STANDARD PICKUP</GlobalServiceName>
          <LocalServiceTypeName>NON STANDARD PICKUP</LocalServiceTypeName>
          <SOfferedCustAgreement>Y</SOfferedCustAgreement>
          <ChargeCodeType>INC</ChargeCodeType>
          <MrkSrvInd>N</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>QA</LocalServiceType>
          <GlobalServiceName>DEDICATED PICKUP</GlobalServiceName>
          <LocalServiceTypeName>DEDICATED PICKUP</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>SA</LocalServiceType>
          <GlobalServiceName>DELIVERY SIGNATURE</GlobalServiceName>
          <LocalServiceTypeName>DELIVERY SIGNATURE</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <MrkSrv>
          <LocalServiceType>TA</LocalServiceType>
          <GlobalServiceName>DEDICATED DELIVERY</GlobalServiceName>
          <LocalServiceTypeName>DEDICATED DELIVERY</LocalServiceTypeName>
          <SOfferedCustAgreement>N</SOfferedCustAgreement>
          <ChargeCodeType>XCH</ChargeCodeType>
          <MrkSrvInd>Y</MrkSrvInd>
        </MrkSrv>
        <SBTP>
          <Prod>
            <VldSrvComb>
              <SpecialServiceType>AB</SpecialServiceType>
              <LocalServiceType>AB</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>AD</SpecialServiceType>
              <LocalServiceType>AD</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>FF</SpecialServiceType>
              <LocalServiceType>FF</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>GG</SpecialServiceType>
              <LocalServiceType>GG</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>II</SpecialServiceType>
              <LocalServiceType>II</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>JA</SpecialServiceType>
              <LocalServiceType>JA</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>OB</SpecialServiceType>
              <LocalServiceType>OB</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>OO</SpecialServiceType>
              <LocalServiceType>OO</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>PA</SpecialServiceType>
              <LocalServiceType>PA</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>PC</SpecialServiceType>
              <LocalServiceType>PC</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>PX</SpecialServiceType>
              <LocalServiceType>PX</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>QA</SpecialServiceType>
              <LocalServiceType>QA</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>SA</SpecialServiceType>
              <LocalServiceType>SA</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
            <VldSrvComb>
              <SpecialServiceType>TA</SpecialServiceType>
              <LocalServiceType>TA</LocalServiceType>
              <CombRSrv>
                <RestrictedSpecialServiceType/>
                <RestrictedLocalServiceType/>
              </CombRSrv>
            </VldSrvComb>
          </Prod>
        </SBTP>
      </Srv>
    </Srvs>
  </GetQuoteResponse>
</res:DCTResponse>'
end

def conditon_error_response
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?><res:DCTResponse xmlns:res='http://www.dhl.com' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation= 'http://www.dhl.com DCT-Response.xsd'><GetQuoteResponse><Response><ServiceHeader><MessageTime>2013-05-31T22:49:42.138+01:00</MessageTime><SiteID>Desere</SiteID></ServiceHeader></Response><Note><Condition><ConditionCode>5021</ConditionCode><ConditionData>The declared value is missing.                                                                       </ConditionData></Condition></Note></GetQuoteResponse></res:DCTResponse>\n"
end