require 'rubygems'
require 'lib/companies_house'

begin
  require 'spec'
rescue LoadError
  puts "\nYou need to install the rspec gem to perform meta operations on this gem"
  puts "  sudo gem install rspec\n"
end

begin
  require 'echoe'

  Echoe.new("companies-house", CompaniesHouse::VERSION) do |m|
    m.author = ["Rob McKinnon"]
    m.email = ["rob ~@nospam@~ rubyforge.org"]
    m.description = File.readlines("README").first
    m.rubyforge_name = "companies-house"
    m.rdoc_options << '--inline-source'
    m.rdoc_pattern = ["README", "CHANGELOG", "LICENSE"]
    m.dependencies = ["hpricot >=0.6", "haml >=2.0.9", "morph >=0.3.1"]
    # m.executable_pattern = 'bin/companies_house'
  end

rescue LoadError
  puts "\nYou need to install the echoe gem to perform meta operations on this gem"
  puts "  sudo gem install echoe\n\n"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/companies_house.rb"
end

desc "Run all examples with RCov"
task :rcov do
  sh '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -Ilib -S rcov --text-report  -o "coverage" -x "Library" spec/lib/**/*'
end