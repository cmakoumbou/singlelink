require 'test_helper'

class AnalyticsTest < ActionDispatch::IntegrationTest

	setup do
    @user = FactoryGirl.create(:user)
    @subscription = FactoryGirl.create(:subscription, owner_id: @user.id, email: @user.email)
  end

	test "analytics page updates after a visit from a user" do

		# Joe logs in, visits the analytics page then signs out
		get '/sign_in'
		assert_response :success
		post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => 'password'
		assert_equal '/', path
		assert_equal 'Signed in successfully.', flash[:notice]
		get '/analytics'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}
		delete_via_redirect destroy_user_session_path
		assert_equal '/', path
		assert_equal 'Signed out successfully.', flash[:notice]

		# Bob logs in, visits joe's profile then signs out
		get '/sign_in'
		assert_response :success
		post_via_redirect user_session_path, 'user[email]' => 'bob@company.com', 'user[password]' => 'password'
		assert_equal '/', path
		assert_equal 'Signed in successfully.', flash[:notice]
		get '/' + @user.username
		assert_response :success
		delete_via_redirect destroy_user_session_path
		assert_equal '/', path
		assert_equal 'Signed out successfully.', flash[:notice]

		# Joe logs in, visits analytics page then analytics year page
		get '/sign_in'
		assert_response :success
		post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => 'password'
		assert_equal '/', path
		assert_equal 'Signed in successfully.', flash[:notice]
		get '/analytics'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 1 | Unique Visits: 1"}
		get '/analytics/year'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 1 | Unique Visits: 1"}
	end


	test "analytics page does not update after a visit to your own profile" do
		get '/sign_in'
		assert_response :success
		post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => 'password'
		assert_equal '/', path
		assert_equal 'Signed in successfully.', flash[:notice]

		get '/analytics'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}

		get '/' + @user.username
 		assert_response :success

		get '/analytics'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}
	end

	test "analytics page does not update after a visit to your own profile without logging in" do
		get '/' + @user.username
		assert_response :success

		get '/sign_in'
		assert_response :success
		post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => 'password'
		assert_equal '/', path
		assert_equal 'Signed in successfully.', flash[:notice]

		get '/analytics'
		assert_response :success
		assert_select 'p.text-center', {:count=>1, :text=>"Profile Views: 0 | Unique Visits: 0"}
	end
end