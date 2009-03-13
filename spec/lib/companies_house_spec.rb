require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CompaniesHouse do

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

    @transaction_id = 123
    Time.stub!(:now).and_return(mock('time', :to_i => @transaction_id))
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
  end

  describe "when asked for name search request" do
    it 'should perform request correctly' do
      CompaniesHouse::Request.should_receive(:name_search_xml).with(:company_name=> @company_name).and_return @request_xml
      CompaniesHouse.should_receive(:post).with(@request_xml).and_return @response_xml
      CompaniesHouse.name_search(@company_name).should == @response_xml
    end
  end

  describe "when asked for number search request" do
    it 'should perform request correctly' do
      CompaniesHouse::Request.should_receive(:number_search_xml).with(:company_number=> @company_number).and_return @request_xml
      CompaniesHouse.should_receive(:post).with(@request_xml).and_return @response_xml
      CompaniesHouse.number_search(@company_number).should == @response_xml
    end
  end
end