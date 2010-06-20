class Cart
  attr_reader :items
  def initialize
    @items = []
  end
  def add_product(product)
    #@items<<product
    current_item = @items.find{|item| item.product==product}
    if current_item
      current_item.increment_quantity
    end
    puts "@items: #{@items}"
    puts "current_item : #{current_item}"

    @items << CartItem.new(product)
  end


end