class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items == nil 
      raise IllegalArgument
    else
      @items = items
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

end
