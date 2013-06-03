require_relative 'test_helper'
require_relative '../../lib/todo_list'
require_relative '../../lib/todo_item'

describe TodoList do
  include TestHelper

  it "should persist itself" do
    TodoList.create()
    TodoList.count.should == 1
  end

  context "after save" do
    subject(:list) { TodoList.create() }

    it "should return the number of items" do
      list.items_count.should == 0
      list << "Shopping"
      list << "Hair cut"
      list.items_count.should == 2
    end

    it "allow to add an item" do
      list << "Shopping"
      list.items_count.should == 1
    end

    it "should not add an empty item" do
      list << ""
      list.items_count.should == 0
    end

    it "should return an item" do
      list << "Shopping"
      list.get_todo_item(0).title.should == "Shopping"
    end

    it "should return item status" do
      list << "Shopping"
      list.todo_item_completed?(0).should == false
    end

    it "should allow to change the item's status" do
      list << "Shopping"
      list.todo_item_completed?(0).should == false
      list.complete_todo_item(0,true)
      list.todo_item_completed?(0).should == true
    end
  end
end

