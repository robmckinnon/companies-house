require 'rubygems'
gem 'rspec'
require 'spec'

require File.dirname(__FILE__) + '/../lib/companies_house'

def fixture(filename)
  open("#{File.dirname(__FILE__)}/fixtures/#{filename}").read
end