require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

	# Requiring logged-in users

	test "should redirect index when not logged in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should redirect pro when not logged in" do
    get :pro
    assert_redirected_to new_user_session_path
  end

  test "should redirect cancel when not logged in" do
    get :cancel
    assert_redirected_to new_user_session_path
  end

  test "should redirect resume when not logged in" do
    get :resume
    assert_redirected_to new_user_session_path
  end

  test "should redirect card when not logged in" do
    get :card
    assert_redirected_to new_user_session_path
  end

  # Authorization

  test "should only be able to access pro page when no sub" do
  	user = users(:peter)
  	ability = Ability.new(user)
  	assert ability.can?(:pro, Subscription.new)
  	assert ability.cannot?(:card, Subscription.new)
  	assert ability.cannot?(:cancel, Subscription.new)
  	assert ability.cannot?(:resume, Subscription.new)
  end

  test "should only be able to access card and cancel when active sub" do
  	user = users(:travis)
  	ability = Ability.new(user)
  	assert ability.can?(:card, Subscription.new)
  	assert ability.can?(:cancel, Subscription.new)
  	assert ability.cannot?(:resume, Subscription.new)
  	assert ability.cannot?(:pro, Subscription.new)
  end

  test "should only be able to access card and resume when canceled sub and end_date > Time.now" do
  	user = users(:elise)
  	ability = Ability.new(user)
  	assert ability.can?(:card, Subscription.new)
  	assert ability.can?(:resume, Subscription.new)
  	assert ability.cannot?(:cancel, Subscription.new)
  	assert ability.cannot?(:pro, Subscription.new)
  end

  test "should only be able to access pro when canceled sub and end_date < Time.now" do
  	user = users(:ciara)
  	ability = Ability.new(user)
    assert ability.can?(:renew, Subscription.new)
  	assert ability.cannot?(:card, Subscription.new)
  	assert ability.cannot?(:cancel, Subscription.new)
  	assert ability.cannot?(:resume, Subscription.new)
  end

  test "should only be able to access card and cancel when past_due sub" do
  	user = users(:laura)
  	ability = Ability.new(user)
  	assert ability.can?(:card, Subscription.new)
  	assert ability.can?(:cancel, Subscription.new)
  	assert ability.cannot?(:pro, Subscription.new)
  	assert ability.cannot?(:resume, Subscription.new)
  end
end
