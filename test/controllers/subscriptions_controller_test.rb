require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
    @subscription = FactoryGirl.create(:subscription, owner_id: @user.id, email: @user.email)
  end

  # Requiring logged-in users

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should not redirect pricing when not logged in" do
    get :pricing
    assert_template 'subscriptions/pricing'
  end

  # Subscription test

  test "index when subscribed" do
    sign_in @user
    get :index
    assert_template 'subscriptions/index'
  end

  test "index when not subscribed" do
    sign_in @user_2
    get :index
    assert_redirected_to pricing_path
  end

  test "pricing when subscribed" do
    sign_in @user
    get :pricing
    assert_redirected_to subscription_path
  end

  test "pricing when not subscribed" do
    sign_in @user_2
    get :pricing
    assert_template 'subscriptions/pricing'
  end
end
