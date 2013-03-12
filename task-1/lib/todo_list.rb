class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items == nil 
      raise IllegalArgument
    else
      @items = items
      @status = []
      @items.each do |item|
        @status << false
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

    def complete(index)
      @status[index] = true
    end
  
    def uncomplete(index)
      @status[index] = false
    end

    def completed?(object)
      true if @status[object] == true
    end
end
