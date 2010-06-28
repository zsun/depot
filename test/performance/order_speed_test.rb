require 'test_helper'
require 'store_controller'

class OrderSpeedTest <ActionController::TestCase
  tests StoreController
  def setup
    @controller = StoreController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  perf_fix_path = File.join(File.dirname(__FILE__), "../fixtures/performance")
  puts "performance fixture: " + perf_fix_path

  # note: by doing this, the test will not look at the fixture of /test/fixtures/products.yml file
  self.fixture_path = File.join(File.dirname(__FILE__), "../fixtures/performance")
  fixtures :products

  DAVES_DETAILS = {
    :name => "Dave Thomas" ,
    :address => "123 The Street" ,
    :email => "dave@pragprog.com" ,
    :pay_type => "check"
  }
  def test_100_orders
    Order.delete_all
    LineItem.delete_all

    puts "product count: #{Product.find(:all).size}"
    Product.find(:all).each do |p|
      puts "#{p.id}  : #{p.title}"
    end
    # at this point, the product "id : title"" looks like - 1007307538  : Product Number 1
    # Q: strange, why does the product id get random assigned?
    # A: this is becasue the fixture file (product.yml) had wrong setting for product id
    # I should do   id: <%= i%>, but I put down   id: <% i%>
    Product.find(99)
    puts "product: #{Product.find(99)}"


    @controller.logger.silence do
      elapsed_time = Benchmark.realtime do
        100.downto(1) do |prod_id|
          cart = Cart.new
          # jim: right now, got error of ActiveRecord::RecordNotFound: Couldn't find Product with ID=100
          # A: this is because the product id is randomly assigned
          a_product=Product.find(prod_id)
          cart.add_product(a_product)
          post :save_order,
              {:order=> DAVES_DETAILS  },
              {:cart=>cart}
          assert_redirected_to :action=>"index"
        end
      end
      assert_equal 100, Order.find(:all).size
      #Q: why do I get error of "NameError: undefined local variable or method `elapsed_time' for #<OrderSpeedTest:0x5387e9c>"
      #A: because I initially put the following assertion after the next end keyword
      puts "********* elapsed_time: #{elapsed_time}"
      assert elapsed_time < 3.00
    end

  end
end