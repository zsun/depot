require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "index" do
    get :index
    # assert_response :success #200
    assert_response :redirect #302
  end

  test "index without user" do
    get :index
    assert_redirected_to :action=>"login"
    assert_equal "Please log in", flash[:notice]
  end

  fixtures :users
  test "index with user" do
    # here the {} parameter is used for passing into the action
    # the 3rd parameter is used for populating the session data
    get :index, {}, {:user_id=>users(:dave).id}
    assert_response :success
    assert_template "index"
  end

  test "login" do
    dave =users(:dave)
    # notice we are doing a post action here
    post :login, :name=>dave.name, :password=>'secret'
    assert_redirected_to :action=>"index"
    assert_equal dave.id, session[:user_id]
  end

  test "bad password" do
    dave =users(:dave)
    post :login, :name=>dave.name, :password=>'wrong'
    assert_template "login"
  end
end
