require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end

  context "with many items" do
    subject(:list)      { TodoList.new(items) }
    let(:items)         { [1, 2, 3, 5, 4] }
    
    it "return completed items" do
      list.complete(0)
      list.complete(1)
      list.get_completed.should == [1, 2]
    end
      
    it "return uncompleted items" do
      list.complete(0)
      list.complete(1)
      list.get_uncompleted.should == [3, 5, 4]
    end

    it "remove item" do
      list.delete_at(1)
      list.get_all_items.should == [1, 3, 5, 4]
    end
    
    it "remove completed items" do
      list.complete(0)
      list.complete(1)
      list.delete_completed.should == [3, 5, 4]
    end

    it "reverting order of two items" do
      list.reverse(0, 1).should == [2, 1, 3, 5, 4]
    end
    
    it "toggling the state of an item" do
      list.toggle(1)
      list.completed?(1).should be_true
    end

    it "setting the state of the item to uncompleted" do
      list.complete(1)
      list.uncomplete(1)
      list.completed?(1).should be_false
    end

    it "changing the description of an item" do
      list.set_description(1, 9).should == [1, 9, 3, 5, 4]
    end

    it "sorting items by name" do
      list.sort.should == [1, 2, 3, 4, 5]
    end

    it "conversion of the list to text"
  end
end
