require 'bundler/setup'
require 'active_record'
require 'rspec/expectations'
require 'rr'
require 'nulldb_rspec'
require 'nulldb/rails'

module Rails
  def self.root
    File.join(File.dirname(__FILE__),"..","..")
  end
end

ActiveRecord::Base.configurations.merge!('test' => { :adapter => :nulldb })
include NullDB::RSpec::NullifiedDatabase

RSpec.configure do |config|
  config.mock_with :rr
end
