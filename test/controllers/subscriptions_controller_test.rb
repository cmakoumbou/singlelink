require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get cancel" do
    get :cancel
    assert_response :success
  end

  test "should get change" do
    get :change
    assert_response :success
  end

end
