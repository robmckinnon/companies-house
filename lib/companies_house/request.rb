module CompaniesHouse
  module Request

    class << self
      def name_search_xml options
        create default(options).merge(:request_type=>'NameSearch', :template=>'name_search')
      end

      def number_search_xml options
        create default(options).merge(:request_type=>'NumberSearch', :template=>'number_search')
      end

      def company_details_xml options
        create default(options).merge(:request_type=>'CompanyDetails', :template=>'company_details')
      end

      private

      def default options
        options[:search_rows] = 20 unless options.has_key?(:search_rows)
        options[:data_set] = 'LIVE' unless options.has_key?(:data_set)
        options[:same_as] = nil unless options.has_key?(:same_as)
        options[:continuation_key] = nil unless options.has_key?(:continuation_key)
        options[:regression_key] = nil unless options.has_key?(:regression_key)
        options
      end

      def create options={}
        template = options.delete(:template)
        transaction_id, digest = CompaniesHouse.create_transaction_id_and_digest(options)
        params = {:digest => digest,
          :digest_method => CompaniesHouse.digest_method,
          :sender_id => CompaniesHouse.sender_id,
          :password => CompaniesHouse.password,
          :email => '',
          :transaction_id => transaction_id }.merge(options)

        render_request options[:request_type], template, params
      end

      def render_request request_type, template, params
        xml = render_message(request_type, template, params)
        xml.sub!("header_ns=''",header_ns)
        xml.sub!("request_ns=''",request_ns(request_type))
        xml.sub!('<Keys></Keys>','<Keys/>')
        xml.sub!("version='1.0' encoding='utf-8' ", 'version="1.0" encoding="UTF-8"')
        xml
      end

      def render_message request_type, template, params
        unless @request_engine
          request_haml = IO.read(File.dirname(__FILE__) + "/request.haml")
          @request_engine = Haml::Engine.new(request_haml)
        end
        @request_engine.render(Object.new, params.merge(:body=>render_body(template, params)))
      end

      def render_body template, params
        body_haml = IO.read(File.dirname(__FILE__) + "/#{template}.haml")
        engine = Haml::Engine.new(body_haml)
        engine.render(Object.new, params)
      end

      def header_ns
        %Q|xsi:schemaLocation="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch.xsd" xmlns="http://www.govtalk.gov.uk/schemas/govtalk/govtalkheader" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"|
      end

      def request_ns request_type
        %Q|xmlns="http://xmlgw.companieshouse.gov.uk/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/v1-0/schema/#{request_type}.xsd"|
      end
    end

  end
end

