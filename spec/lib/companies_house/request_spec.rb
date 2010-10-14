require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe CompaniesHouse::Request do

  before do
    @transaction_id = 123
    @digest = '????'
    @sender_id = 'XMLGatewayTestUserID'
    @email = 'x@y'
    CompaniesHouse.sender_id = @sender_id
    CompaniesHouse.email = @email
    CompaniesHouse.stub!(:create_transaction_id_and_digest).and_return [@transaction_id, @digest]

    @name_search_type = 'NameSearch'
    @company_name = 'millennium stadium plc'
    @name_search_xml = expected_xml @name_search_type, %Q|<NameSearchRequest xmlns="http://xmlgw.companieshouse.gov.uk/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/v1-0/schema/NameSearch.xsd">
      <CompanyName>millennium stadium plc</CompanyName>
      <DataSet>LIVE</DataSet>
      <SearchRows>20</SearchRows>
    </NameSearchRequest>|

    @number_search_type = 'NumberSearch'
    @company_number = '03176906'
    @number_search_xml = expected_xml @number_search_type, %Q|<NumberSearchRequest xmlns="http://xmlgw.companieshouse.gov.uk/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/v1-0/schema/NumberSearch.xsd">
      <PartialCompanyNumber>#{@company_number}</PartialCompanyNumber>
      <DataSet>LIVE</DataSet>
      <SearchRows>20</SearchRows>
    </NumberSearchRequest>|

    @company_details_type = 'CompanyDetails'
    @company_details_xml = expected_xml @company_details_type, %Q|<CompanyDetailsRequest xmlns="http://xmlgw.companieshouse.gov.uk/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/v1-0/schema/CompanyDetails.xsd">
      <CompanyNumber>#{@company_number}</CompanyNumber>
      <GiveMortTotals>1</GiveMortTotals>
    </CompanyDetailsRequest>|
  end

  describe "when asked for name search request xml" do
    it 'should create xml correctly' do
      request_xml = CompaniesHouse::Request.name_search_xml :company_name => @company_name
      request_xml.strip.should == @name_search_xml.strip
    end

    describe "and same_as flag is set to true" do
      it 'should create xml correctly' do
        request_xml = CompaniesHouse::Request.name_search_xml :company_name => @company_name, :same_as => 'true'
        request_xml.strip.should == @name_search_xml.gsub('      <DataSet>LIVE</DataSet>',"      <DataSet>LIVE</DataSet>\n      <SameAs>true</SameAs>").strip
      end
    end
    describe "and same_as flag is set to false" do
      it 'should create xml correctly' do
        request_xml = CompaniesHouse::Request.name_search_xml :company_name => @company_name, :same_as => 'false'
      request_xml.strip.should == @name_search_xml.strip
      end
    end
    describe "and continuation_key is set" do
      it 'should create xml correctly' do
        request_xml = CompaniesHouse::Request.name_search_xml :company_name => @company_name, :continuation_key => '1234'
        request_xml.strip.should == @name_search_xml.gsub('      <SearchRows>20</SearchRows>',"      <SearchRows>20</SearchRows>\n      <ContinuationKey>1234</ContinuationKey>").strip
      end
    end
    describe "and regression_key is set" do
      it 'should create xml correctly' do
        request_xml = CompaniesHouse::Request.name_search_xml :company_name => @company_name, :regression_key => '4321'
        request_xml.strip.should == @name_search_xml.gsub('      <SearchRows>20</SearchRows>',"      <SearchRows>20</SearchRows>\n      <RegressionKey>4321</RegressionKey>").strip
      end
    end
  end

  describe "when asked for number search request xml" do
    it 'should create xml correctly' do
      request_xml = CompaniesHouse::Request.number_search_xml :company_number => @company_number
      request_xml.strip.should == @number_search_xml.strip
    end
  end

  describe "when asked for company details request xml" do
    it 'should create xml correctly' do
      CompaniesHouse.email = ''
      CompaniesHouse.email.should == ''
      request_xml = CompaniesHouse::Request.company_details_xml :company_number => @company_number
      request_xml.strip.should == @company_details_xml.strip
    end
  end

  def expected_xml request_type, body
%Q|<?xml version="1.0" encoding="UTF-8"?>
<GovTalkMessage xsi:schemaLocation="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch.xsd" xmlns="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <EnvelopeVersion>1.0</EnvelopeVersion>
  <Header>
    <MessageDetails>
      <Class>#{request_type}</Class>
      <Qualifier>request</Qualifier>
      <TransactionID>#{@transaction_id}</TransactionID>
    </MessageDetails>
    <SenderDetails>
      <IDAuthentication>
        <SenderID>#{@sender_id}</SenderID>
        <Authentication>
          <Method>CHMD5</Method>
          <Value>#{@digest}</Value>
        </Authentication>
      </IDAuthentication>
      <EmailAddress>#{}</EmailAddress>
    </SenderDetails>
  </Header>
  <GovTalkDetails>
    <Keys/>
  </GovTalkDetails>
  <Body>
    #{body}
  </Body>
</GovTalkMessage>|
  end

end