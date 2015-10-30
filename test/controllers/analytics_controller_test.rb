require 'test_helper'

class AnalyticsControllerTest < ActionController::TestCase

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

  test "should redirect year when not logged in" do
    get :year
    assert_redirected_to new_user_session_path
  end

  test "should redirect showcase when not logged in" do
    get :showcase
    assert_redirected_to new_user_session_path
  end

  # Analytics index test

  test "index when subscribed" do
    sign_in @user
    get :index
    assert_template 'analytics/index'
    assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}
    assert_select 'div.panel-heading.profile-views', {:text=>"Profile Views per day - Timezone: London - ( Change Timezone )"}
    assert_select 'div.panel-heading.profile-city',
     {:text=>"Profile visits by City - Country: United Kingdom - ( Change Country )"}
    assert_select 'div#chart-1', 1
    assert_select 'div#chart-2', 1
    assert_select 'div#chart-3', 1
    assert_select 'div#chart-4', 1
  end

  test "index when not subscribed" do
    sign_in @user_2
    get :index
    assert_redirected_to analytics_showcase_path
  end

  # Analytics year test

  test "index (year) when subscribed" do
    sign_in @user
    get :year
    assert_template 'analytics/year'
    assert_select 'div.panel-heading.analytics-title', {:count=>1,
     :text=>"Analytics - One Year Report: #{Time.now.in_time_zone(users(:bob).time_zone).strftime("%Y")} - ( View One Month Report )"}
    assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}
    assert_select 'div.panel-heading.profile-views', {:text=>"Profile Views per day - Timezone: London - ( Change Timezone )"}
    assert_select 'div.panel-heading.profile-city',
     {:text=>"Profile visits by City - Country: United Kingdom - ( Change Country )"}
    assert_select 'div#chart-1', 1
    assert_select 'div#chart-2', 1
    assert_select 'div#chart-3', 1
    assert_select 'div#chart-4', 1
  end

  test "index (year) when not subscribed" do
    sign_in @user_2
    get :year
    assert_redirected_to analytics_showcase_path
  end
end


