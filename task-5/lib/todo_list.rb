require 'active_record'

class TodoList < ActiveRecord::Base
  has_many :todo_items
  attr_writer :item_factory

  ########################
  # Domain-specific calls.
  ########################
  def empty?
    self.items_count == 0
  end

  def size
    self.items_count
  end

  def <<(item)
    add_todo_item(item)
  end

  def toggle_state(index)
    complete_todo_item(index,!todo_item_completed?(index))
  end

  def first
    get_todo_item(0)
  end

  def last
    get_todo_item(self.size-1)
  end


  #############################
  # Persistence-specific calls.
  #############################

  def items_count
    self.todo_items.count
  end

  def add_todo_item(item)
    if item.respond_to?(:title) && item.respond_to?(:description)
      item = item_factory.new(title: item.title, description: item.description)
    else
      item = item_factory.new(title: item.to_s)
    end
    item.todo_list = self
    item.save if item.valid?
  end

  def get_todo_item(index)
    self.todo_items.offset(index).first
  end

  def todo_item_completed?(index)
    get_todo_item(index).completed?
  end

  def complete_todo_item(index,status)
    get_todo_item(index).update_attribute(:completed,status)
  end

  protected
  def item_factory
    @item_factory ||= TodoItem
  end
end
