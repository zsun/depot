class StoreController < ApplicationController
 def index
    @products=Product.find_product_for_sale
    @cart=find_cart
 end

 #must be public
 def add_to_cart
    product=Product.find(params[:id])
    @cart=find_cart
    puts "found product: #{product.title}"
    # @current_item is an instance variable, has the info about the current info, so we can pass on to the tempatle
    @current_item = @cart.add_product(product)
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
    #redirect_to_index
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product: #{params[:id]}")
    flash[:notice]="Invalid product"
    redirect_to_index("Invalid Product!")
  end

  def empty_cart
    session[:cart]=nil
    # flash[:notice] = "your cart is currently empty"
    #redirect_to :action=>'index'
    redirect_to_index("your cart is currently empty")
  end

  def checkout
    @cart = find_cart
    if @cart.items.empty?
       redirect_to_index("Your cart is empty")
    else
      @order=Order.new
    end
  end

 def save_order
   @cart = find_cart
   @order = Order.new(params[:order])
   @order.add_line_items_from_cart(@cart)
   if @order.save
     session[:cart] = nil
     redirect_to_index("Thank you for your order")
   else
    render :action=> 'Check out'
   end
 end

 private
 def find_cart
    session[:cart] ||= Cart.new
 end

 def find_cart_verbose
    unless session[:cart]
      session[:cart]= Cart.new
    end
    session[:cart]
 end

 def redirect_to_index(msg=nil)
   flash[:notice]=msg if msg
   redirect_to :action=>'index'
 end

end