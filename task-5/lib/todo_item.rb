require 'active_record'

class TodoItem < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :todo_list
end
