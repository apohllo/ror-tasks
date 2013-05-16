require 'active_record'

class Book < ActiveRecord::Base
  validates :title, :presence => true
end
