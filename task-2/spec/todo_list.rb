require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0,false) { true }

    list.toggle_state(0)
    list.toggle_state(0)
  end

  it "should fetch the first item from the DB" do
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end
end
