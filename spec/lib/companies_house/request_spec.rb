require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe CompaniesHouse::Request do

  before do
    @transaction_id = 123
    @digest = '????'
    @sender_id = 'XMLGatewayTestUserID'
    @email = 'x@y'
    CompaniesHouse.sender_id = @sender_id
    CompaniesHouse.email = @email
    CompaniesHouse.stub(:create_transaction_id_and_digest).and_return [@transaction_id, @digest]

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

    @company_incorporation_type = 'FormSubmission'
    @company_incorporation_xml = expected_xml @company_incorporation_type, %Q|<NumberSearchRequest xmlns="http://xmlgw.companieshouse.gov.uk/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/v1-0/schema/FormSubmission.xsd">
      <PartialCompanyNumber>03176906</PartialCompanyNumber>
      <DataSet>LIVE</DataSet>
      <SearchRows>20</SearchRows>
    </NumberSearchRequest>
  </Body>
  <Body>
    <FormSubmission xmlns:bs='http://xmlgw.companieshouse.gov.uk' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xmlgw.companieshouse.gov.uk/Header' xsi:schemalocation='http://xmlgw.companieshouse.gov.uk/Header http://xmlgw.companieshouse.gov.uk/v1-0/schema/forms/FormSubmission-v1-1.xsd'>
      <Formheader>
        <CompanyName>TEST INC COMPANY LTD</CompanyName>
        <PackageReference>1828</PackageReference>
        <FormIdentifier>CompanyIncorporation</FormIdentifier>
        <SubmissionNumber>SUB006</SubmissionNumber>
      </Formheader>
      <Authority>
        <Designation>AGENT</Designation>
        <DateSigned>2008-05-31</DateSigned>
      </Authority>
      <Form>
        <CompanyIncorporation xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xmlgw.companieshouse.gov.uk' xsi:schemalocation='http://xmlgw.companieshouse.gov.uk http://xmlgw.companieshouse.gov.uk/v1-0/schema/forms/CompanyIncorporation-v1-1.xsd'>
          <SameDay>false</SameDay>
          <RegisteredOfficeAddress>
            <Premise>10</Premise>
            <Street>The Street</Street>
            <Thoroughfare>Titchfield</Thoroughfare>
            <PostTown>Fareham</PostTown>
            <County>Hants</County>
            <Country>UK</Country>
            <Postcode>PO14 4HW</Postcode>
          </RegisteredOfficeAddress>
          <CompanyType>BYSHR</CompanyType>
          <CountryOfIncorporation>EW</CountryOfIncorporation>
          <Agent>
            <Person>
              <Forename>Edwin</Forename>
              <Surname>Crockford</Surname>
            </Person>
            <Address>
              <Premise>10</Premise>
              <Street>The Street</Street>
              <Thoroughfare></Thoroughfare>
              <PostTown>Cardiff</PostTown>
              <Postcode>CF14 3UZ</Postcode>
            </Address>
          </Agent>
          <Appointment>
            <Authentication>
              <PersonalAttribute>BIRTOWN</PersonalAttribute>
              <PersonalData>Sco</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>PASSNO</PersonalAttribute>
              <PersonalData>234</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>EYE</PersonalAttribute>
              <PersonalData>Blu</PersonalData>
            </Authentication>
            <Director>
              <Address>
                <Premise>10</Premise>
                <Street>The Street</Street>
                <Thoroughfare></Thoroughfare>
                <PostTown>Cardiff</PostTown>
                <Postcode>CF14 3UZ</Postcode>
              </Address>
              <Person>
                <Surname>Crockford</Surname>
                <Forename>Phil</Forename>
                <Honours>BEng</Honours>
                <DOB>1959-09-04</DOB>
                <Nationality>British</Nationality>
                <Occupation>Hacker</Occupation>
              </Person>
            </Director>
          </Appointment>
          <Appointment>
            <Authentication>
              <PersonalAttribute>NATINS</PersonalAttribute>
              <PersonalData>YR1</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>BIRTOWN</PersonalAttribute>
              <PersonalData>Sco</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>PASSNO</PersonalAttribute>
              <PersonalData>234</PersonalData>
            </Authentication>
            <Secretary>
              <Address>
                <Premise>10</Premise>
                <Street>The Street</Street>
                <PostTown>Cardiff</PostTown>
                <Postcode>CF14 3UZ</Postcode>
              </Address>
              <Corporate>
                <Forename>Chris</Forename>
                <Surname>Smith</Surname>
                <CorporateName>The Nominee Corp</CorporateName>
              </Corporate>
            </Secretary>
          </Appointment>
          <AuthorisedCapital>
            <ShareClass>Ordinary</ShareClass>
            <Currency>GBP</Currency>
            <AuthorisedCapital>1000</AuthorisedCapital>
            <NumShares>5000</NumShares>
            <ShareValue>0.2</ShareValue>
          </AuthorisedCapital>
          <Subscribers>
            <TotalNumberShares>200</TotalNumberShares>
            <Subscriber>
              <PersonalAuthenticationCode>040101</PersonalAuthenticationCode>
              <NumShares>100</NumShares>
            </Subscriber>
            <Subscriber>
              <Corporate>
                <Forename>Fred</Forename>
                <Surname>Williams</Surname>
                <CorporateName>The Investment Company</CorporateName>
              </Corporate>
              <Address>
                <Premise>10</Premise>
                <Street>The Street</Street>
                <Thoroughfare></Thoroughfare>
                <PostTown>Cardiff</PostTown>
                <Postcode>CF14 3UZ</Postcode>
              </Address>
              <Authentication>
                <PersonalAttribute>NATINS</PersonalAttribute>
                <PersonalData>YR1</PersonalData>
              </Authentication>
              <Authentication>
                <PersonalAttribute>BIRTOWN</PersonalAttribute>
                <PersonalData>Sco</PersonalData>
              </Authentication>
              <Authentication>
                <PersonalAttribute>PASSNO</PersonalAttribute>
                <PersonalData>234</PersonalData>
              </Authentication>
              <NumShares>100</NumShares>
            </Subscriber>
          </Subscribers>
          <Declarant>
            <Person>
              <Forename>Edwin</Forename>
              <Surname>Crockford</Surname>
            </Person>
            <Address>
              <Premise>10</Premise>
              <Street>The Street</Street>
              <Thoroughfare></Thoroughfare>
              <PostTown>Cardiff</PostTown>
              <Postcode>CF14 3UZ</Postcode>
            </Address>
            <Authentication>
              <PersonalAttribute>BIRTOWN</PersonalAttribute>
              <PersonalData>Sco</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>PASSNO</PersonalAttribute>
              <PersonalData>234</PersonalData>
            </Authentication>
            <Authentication>
              <PersonalAttribute>EYE</PersonalAttribute>
              <PersonalData>Blu</PersonalData>
            </Authentication>
            <IncDesignation>SOLICITOR</IncDesignation>
          </Declarant>
        </CompanyIncorporation>
      </Form>
      <Document>
        <Data>TWVtb3JhbmR1bSBhbmQgQXJ0aWNsZXM=</Data>
        <Date>2008-04-27</Date>
        <Filename>MemArts.pcl</Filename>
        <ContentType>application/vnd.hp-pcl</ContentType>
        <Category>MEMARTS</Category>
      </Document>
    </FormSubmission>|
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
    describe "and sender_id and password given in options" do
      it "should use given sender_id and password when creating transaction_id and digest" do
        CompaniesHouse.should_receive(:create_transaction_id_and_digest).with(hash_including(:sender_id => 'foo123', :password => 'bar456'))
        CompaniesHouse::Request.name_search_xml(:company_name => @company_name, :sender_id => 'foo123', :password => 'bar456')
      end
    end
  end

  describe "when asked for number search request xml" do
    it 'should create xml correctly' do
      request_xml = CompaniesHouse::Request.number_search_xml :company_number => @company_number
      request_xml.strip.should == @number_search_xml.strip
    end
    
    describe "and sender_id and password given in options" do
      it "should use given sender_id and password when creating transaction_id and digest" do
        CompaniesHouse.should_receive(:create_transaction_id_and_digest).with(hash_including(:sender_id => 'foo123', :password => 'bar456'))
        CompaniesHouse::Request.number_search_xml(:company_number => @company_number, :sender_id => 'foo123', :password => 'bar456')
      end
    end
  end

  describe "when asked for company details request xml" do
    it 'should create xml correctly' do
      CompaniesHouse.email = ''
      CompaniesHouse.email.should == ''
      request_xml = CompaniesHouse::Request.company_details_xml :company_number => @company_number
      request_xml.strip.should == @company_details_xml.strip
    end
    
    describe "and sender_id and password given in options" do
      it "should use given sender_id and password when creating transaction_id and digest" do
        CompaniesHouse.should_receive(:create_transaction_id_and_digest).with(hash_including(:sender_id => 'foo123', :password => 'bar456'))
        CompaniesHouse::Request.company_details_xml(:company_number => @company_number, :sender_id => 'foo123', :password => 'bar456')
      end
    end
  end

  describe "when incorporating a company request xml" do
    it "should create xml correctly" do
      request_xml = CompaniesHouse::Request.company_incorporation_xml :company_number => @company_number
      request_xml.strip.should == @company_incorporation_xml.strip
    end
  end

  def expected_xml request_type, body
%Q|<GovTalkMessage xsi:schemaLocation="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch.xsd" xmlns="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
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