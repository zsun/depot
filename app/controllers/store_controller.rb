class StoreController < ApplicationController
  def index
    @products=Product.find_product_for_sale
  end

 #must be public
 def add_to_cart
    product=Product.find(params[:id])
    @cart=find_cart
    puts "found product: #{product.title}"
    @cart.add_product(product)
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product: #{params[:id]}")
    flash[:notice]="Invalid product"
    redirect_to :action=>"index"

  end
  def empty_cart
    session[:cart]=nil
    # flash[:notice] = "your cart is currently empty"
    #redirect_to :action=>'index'
    redirect_to_index("your cart is currently empty")
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
 def redirect_to_index(msg)
   flash[:notice]=msg
   redirect_to :action=>'index'
 end

end
