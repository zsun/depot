require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :products
  def setup
     #here we need to use instance variables
     @cart = Cart.new
     @rails_book=products(:rails_book)
     @ruby_book=products(:ruby_book)
  end
  test "add unique product" do

     @cart.add_product @rails_book
     @cart.add_product @ruby_book
     assert_equal 2, @cart.items.size
     assert_equal @rails_book.price+@ruby_book.price, @cart.total_price
   end

   test "add duplicate product" do
     2.times do |n|
       @cart.add_product @rails_book
     end

     assert_equal 1, @cart.items.size
     assert_equal @rails_book.price*2, @cart.total_price
  end
end
