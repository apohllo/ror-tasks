class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items == nil 
      raise IllegalArgument
    else
      @items = items
      @tasks = {}
      @items.each do |item|
        @tasks[item] = false
      end
    end
  end
      
    def empty?
      @items.empty?
    end

    def size
      @items.size
    end
    
    def <<(other_object)
      @items << other_object
    end 
    
    def last
      @items.last
    end

    def first
      @items.first
    end 

    def completed(index)
      @tasks[@items[index]] = true
    end
  
    def uncompleted(index)
      @tasks[@items[index]] = false
    end

    def completed?(object)
      true if @tasks[@items[object]] == true
    end

	def change_state(index)
	  @tasks[@items[index]] = true
	end
	
	def [](value)
	  @items[value]
	end
	
	def []= (value, other_object)
	  @items[value] = other_object
	end

    #multiple
    def remove_all
      @items.clear
      @tasks = {}
    end

    def sort
      @items.sort()
    end

	def return_completed
	  completed_items = []
	  @items.each do |item|
	    completed_items << item if @tasks[item] == true
	  end
	  completed_items
	end

	def return_uncompleted
	  uncompleted_items = []
	  @items.each do |item|
	    uncompleted_items << item if @tasks[item] == false
	  end
	  uncompleted_items
	end

  def remove_item(index)
    @items.delete_at(index)
  end

  def remove_completed
    to_remove = []
    @items.each do |item|
      to_remove << item if @tasks[item] == true
    end
    to_remove.each do |item|
      @items.delete(item)
    end
    @items
  end

  def reverse(first=nil, second=nil)
    if first == nil && second == nil
      items = []
      while !@items.empty?
        items << @items.pop
      end
      @items = items
    else
      temp = @items[first]
      @items[first] = @items[second]
      @items[second] = temp
    end
  end

  def toggle_state(index)
    if @tasks[@items[index]] == true
      @tasks[@items[index]] = false
    else
      @tasks[@items[index]] = true
    end
  end

  def text_look
    @items.each do |item|
      if @tasks[item] == true
        p "%s [x]" % [item]
      else
        p "%s [ ]" % [item]
      end
    end
  end
end
