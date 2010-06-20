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


end
