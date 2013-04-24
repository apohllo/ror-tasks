require 'active_record'

class Book < ActiveRecord::Base
  validate :title, :presence => true
end
