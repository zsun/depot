require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :all

  # An end to end test for puchasing
  test "Buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book=products(:ruby_book)

    get "/store/index"
    assert_response :success
    assert_template "index"
    # jim: how do I see the html content of the current page?

    xml_http_request :put, "/store/add_to_cart", :id=> ruby_book.id
    assert_response :ok

    cart=session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product

    # jim: notice how the page is referenced?
    post "/store/checkout"
    assert_response :ok
    assert_template "checkout"

    puts "url from last request: #{path}"

    post_via_redirect "/store/save_order",
              :order=> {:name=> "Dave Smith",
                        :address => "123 main street",
                        :email =>"dave@smith.com",
                        :pay_type=>"check"
                }
    # check the status of the last request
    puts status_message

    headers.each do |h|
      puts "header: #{h}"
    end

    assert_response :ok
    assert_template "index"
    assert_equal 0, session[:cart].items.size

    cookies.each do |h|
      puts "cookie: #{h}"
    end

    # Q: how come this sessions object is not available???
    # A: you should use "session" instead of "sessions"
    session.each do |h|
     puts "session: #{h}"
    end
    # now it is time to query database to see if we have created the order as expected
    orders = Order.find(:all)
    assert_equal 1, orders.size
    order=orders[0]

    assert_equal "Dave Smith",order.name
    assert_equal "123 main street", order.address
    assert_equal "dave@smith.com", order.email
    assert_equal "check", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
  end
end
