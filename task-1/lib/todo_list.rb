class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    raise IllegalArgument if items == nil
    @list = []
    @completed = []
    items.each { |item| self.<<(item) }
  end

  def empty?
    @list.empty?
  end

  def size
    @list.size
  end

  def <<(item)
    @completed << false
    @list << item
  end

  def last
    @list.last
  end

  def first
    @list.first
  end

  def completed?(item)
    @completed[item]
  end

  def complete(item)
    @completed[item] = true
  end
  
  def uncomplete(item)
    @completed[item] = false
  end

  def get_completed
    @list.select.with_index { |v, i| @completed[i] == true }
  end

  def get_uncompleted
    @list.select.with_index { |v, i| @completed[i] == false }
  end

  def get_all_items
    @list
  end

  def delete_at(item)
    @completed.delete_at(item)
    @list.delete_at(item)
  end

  def delete_completed
    @list.delete_if.with_index {|v ,i| @completed[i] == true }
    @completed.delete_if {|v| v == true }
    @list
  end

  def reverse(i1, i2)
    func = lambda do |i1, i2, list|
    tmp = list[i1]
    list[i1] = list[i2]
    list[i2] = tmp
    list
    end

    @completed = func.call i1, i2, @completed
    @list = func.call i1, i2, @list
  end
  
  def toggle(item)
    if(@completed[item] == false)
      @completed[item] = true
    else
      @completed = false
    end
  end

  def set_description(index, desc)
    @list[index] = desc
    @list
  end

  def sort
  end
end
