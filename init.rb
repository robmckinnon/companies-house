begin
  require File.join(File.dirname(__FILE__), 'lib', 'companies_house') # From here
rescue LoadError
  require 'companies-house' # From gem
end
