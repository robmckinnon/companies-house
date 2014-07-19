require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CompaniesHouse do

  describe 'when objectifying xml' do
    describe 'and xml contains response in Body' do
      it 'should return an instance of CompaniesHouse::CompanyDetails' do
        xml = '<Body><company_details><company_name>£IBRA FINANCIAL SERVICES LIMITED</company_name></company_details></Body>'
        object = CompaniesHouse.objectify xml
        object.class.name.should == 'CompaniesHouse::CompanyDetails'
      end
      describe 'and xml contains expanded unicode' do
        it 'should convert to utf8' do
          xml = '<Body><company_details><company_name>£IBRA FINANCIAL SERVICES LIMITED</company_name></company_details></Body>'
          object = CompaniesHouse.objectify xml
          object.company_name.should == "£IBRA FINANCIAL SERVICES LIMITED"
        end
      end
      describe 'and xml contains single sic_text' do
        it 'should convert to sic_code sic_texts' do
          xml = '<Body><company_details><SICCodes><SicText>9261 - Operate sports arenas &amp; stadiums</SicText></SICCodes></company_details></Body>'

          object = CompaniesHouse.objectify xml
          object.sic_codes.sic_text.should == '9261 - Operate sports arenas & stadiums'
          object.sic_codes.sic_texts.should == ['9261 - Operate sports arenas & stadiums']
        end
      end
      describe 'and xml contains no sic_text' do
        it 'should return empty sic_code sic_texts' do
          xml = '<Body><company_details><sic_codes></sic_codes></company_details></Body>'
          object = CompaniesHouse.objectify xml
          object.sic_codes.sic_texts.should == []
        end
        it 'should return empty sic_code sic_texts again' do
          xml = '<Body><company_details><sic_codes><sic_text></sic_text></sic_codes></company_details></Body>'
          object = CompaniesHouse.objectify xml
          object.sic_codes.sic_texts.should == []
        end
      end
      describe 'and xml contains multiple sic codes' do
        it 'should return array of sic codes' do
          xml = '<Body><CompanyDetails><SICCodes><SicText>2960 - Manufacture of weapons &amp; ammunition</SicText><SicText>3410 - Manufacture of motor vehicles</SicText></SICCodes></CompanyDetails></Body>'
          object = CompaniesHouse.objectify xml
          object.sic_codes.sic_texts.should == ['2960 - Manufacture of weapons & ammunition','3410 - Manufacture of motor vehicles']
        end
      end
    end

    describe 'and xml contains Error' do
      it 'should raise CompaniesHouse::Exception' do
        xml = xml_error
        lambda { CompaniesHouse.objectify xml }.should raise_error(CompaniesHouse::Exception)
      end

      it 'should include error message in exception' do
        xml = xml_error
        lambda { CompaniesHouse.objectify xml }.should raise_error(CompaniesHouse::Exception, 'NameSearch fatal 503: Repeat/non-incremental Transaction ID sent with request - Rejecting')
      end

      def xml_error
        %Q|<?xml version="1.0" encoding="UTF-8" ?>
<GovTalkMessage xsi:schemaLocation="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch.xsd" xmlns="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
  <EnvelopeVersion>1.0</EnvelopeVersion>
  <Header>
    <MessageDetails>
      <Class>NameSearch</Class>
      <Qualifier>error</Qualifier>
      <TransactionID>1287070383</TransactionID>
      <GatewayTimestamp>2010-10-14T16:33:04-00:00</GatewayTimestamp>
    </MessageDetails>
    <SenderDetails>
      <IDAuthentication>
        <SenderID>63884537357901904930357805221487</SenderID>
        <Authentication>
          <Method>CHMD5</Method>
          <Value>3985a067aa3f4613adcf3589b420f4e2</Value>
        </Authentication>
      </IDAuthentication>
    </SenderDetails>
  </Header>
  <GovTalkDetails>
    <Keys/>
	<GovTalkErrors>
	  <Error>
	    <RaisedBy>NameSearch</RaisedBy>
	    <Number>503</Number>
	    <Type>fatal</Type>
	    <Text>Repeat/non-incremental Transaction ID sent with request - Rejecting</Text>
	    <Location></Location>
	  </Error>
	</GovTalkErrors>
  </GovTalkDetails>
  <Body>
  </Body>
</GovTalkMessage>|
      end
    end
  end

  describe 'when calling public methods' do
    before do
      @sender_id = 'user'
      @password = '???'
      @email = 'email'

      CompaniesHouse.sender_id = @sender_id
      CompaniesHouse.password = @password
      CompaniesHouse.email = @email

      @company_name = 'millennium stadium plc'
      @company_number = '03176906'
      @request_xml = '<request/>'
      @response_xml = '<response/>'

      float_time = 123.45678
      @transaction_id = 12345
      Time.stub(:now).and_return(double('time', :to_f => float_time))
      @digest = 'digest'
    end

    describe "when asked for credientials" do
      it 'should return sender_id correctly' do
        CompaniesHouse.sender_id.should == @sender_id
      end
      it 'should return password correctly' do
        CompaniesHouse.password.should == @password
      end
      it 'should return email correctly' do
        CompaniesHouse.email.should == @email
      end
    end

    describe 'when asked for a transaction id and digest' do
      it 'should create transaction id and digest correctly' do
        Digest::MD5.should_receive(:hexdigest).with("#{@sender_id}#{@password}#{@transaction_id}").and_return @digest
        transaction_id, digest = CompaniesHouse.create_transaction_id_and_digest
        transaction_id.should == @transaction_id
        digest.should == @digest
      end
      
      describe "and password and sender_id passed as options" do
        it "should use in preference to class ones" do
          Digest::MD5.should_receive(:hexdigest).with("foo1234bar4567#{@transaction_id}")# @digest
          CompaniesHouse.create_transaction_id_and_digest(:sender_id => 'foo1234', :password => 'bar4567')
        end
      end
    end
    
    describe "when asked for name search request" do
      it 'should perform request correctly' do
        CompaniesHouse::Request.should_receive(:name_search_xml).with(:company_name=> @company_name).and_return @request_xml
        CompaniesHouse.should_receive(:get_response).with(@request_xml).and_return @response_xml
        CompaniesHouse.name_search(@company_name).should == @response_xml
      end
    end

    describe "when asked for number search request" do
      it 'should perform request correctly' do
        CompaniesHouse::Request.should_receive(:number_search_xml).with(:company_number=> @company_number).and_return @request_xml
        CompaniesHouse.should_receive(:get_response).with(@request_xml).and_return @response_xml
        CompaniesHouse.number_search(@company_number).should == @response_xml
      end
    end

    describe "when asked for company details request" do
      it 'should perform request correctly' do
        CompaniesHouse::Request.should_receive(:company_details_xml).with(:company_number=> @company_number).and_return @request_xml
        CompaniesHouse.should_receive(:get_response).with(@request_xml).and_return @response_xml
        CompaniesHouse.company_details(@company_number).should == @response_xml
      end
    end
  end
end