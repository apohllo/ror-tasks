require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  def compare_lists(output_list, compare_list)
    output_list.each do |item|
      break if item != compare_list.shift
    end
    compare_list.should be_empty
  end

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

  context "with many itmes" do
      before:each do
        list.remove_items
        list << "Meeting"
        list << "Phone"
        list << "Shopping"
        list << "Carwash"
        list.completed(0)
        list.completed(1)
      end
    it "should return an array of completed items" do
      output_list = list.return_completed
      compare_lists(output_list, ["Meeting","Phone"])
    end

    it "should return an array of uncompleted items" do
      output_list = list.return_uncompleted
      compare_lists(output_list, ["Shopping","Carwash"]) 
    end
    
    it "should remove individual item" do
      
    end

    it "should remove all completed items" do

    end

    it "should revert order of two items" do 

    end

    it "shoulde revert all itmes" do

    end

    it "should toggle the state of the item" do

    end
    
    it "should set the state of the item to uncompleted" do 

    end

    it "should change the description of an item" do 
     
    end

    it "should sort the items by name" do

    end

    it "should do the conversion to text look [ ], [x]" do

    end    
  end
end
