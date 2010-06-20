class CartItem
 # note: the file name to keep this class will have to be called cart_item.rb, can't be cartitem.rb
 # or you will get error of "Constant Cart::CartItem not initialized"
 attr_reader :product, :quantity


  def initialize(product)
    puts "product to add to cart: #{product.title}"
    @product=product
    @quantity=1
  end
  def increment_quantity
   @quantity += 1
 end

  def title
    @product.title
  end
  def price
    @product.price*@quantity
  end
end