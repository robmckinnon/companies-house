require 'rubygems'
require 'net/http'
require 'uri'
require 'open-uri'
require 'digest/md5'

require 'haml'

require File.dirname(__FILE__) + '/companies_house/request'

module CompaniesHouse
  VERSION = "0.0.1" unless defined? CompaniesHouse::VERSION

  class << self
    def name_search name
      xml = CompaniesHouse::Request.name_search_xml :company_name=>name
      post(xml)
    end

    def number_search number
      xml = CompaniesHouse::Request.number_search_xml :company_number=>number
      post(xml)
    end

    def company_details number
      xml = CompaniesHouse::Request.company_details_xml :company_number=>number
      post(xml)
    end

    def post(data)
      begin
        u = "http://xmlgw.companieshouse.gov.uk/v1-0/xmlgw/Gateway"
        puts "Checking url #{u}"
        url = URI.parse u
        http = Net::HTTP.new(url.host, url.port)
        res, body = http.post(url.path, data, {'Content-type'=>'text/xml;charset=utf-8'})
        case res
          when Net::HTTPSuccess, Net::HTTPRedirection
            puts "response #{res.body}"
          else
            puts "problem"
        end
      rescue URI::InvalidURIError
        puts "URI is no good"
      end
    end

    def sender_id= id
      @sender_id = id
    end
    def sender_id
      @sender_id
    end
    def password= pw
      @password = pw
    end
    def password
      @password
    end
    def email= e
      @email = e
    end
    def email
      @email
    end
    def digest_method
      'CHMD5'
    end
    def create_transaction_id_and_digest
      transactionId = Time.now.to_i
      digest = Digest::MD5.hexdigest("#{@sender_id}#{@password}#{transactionId}")
      return transactionId, digest
    end
  end
end
