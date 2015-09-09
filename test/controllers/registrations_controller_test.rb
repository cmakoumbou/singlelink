require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

	setup do
		@request.env["devise.mapping"] = Devise.mappings[:user]
	end

  test "should redirect delete when not logged in" do
  	get :delete
  	assert_redirected_to new_user_session_path
  end

  test "should redirect destroy when not logged in" do
  	get :destroy
  	assert_redirected_to new_user_session_path
  end

  test "should not destroy user with wrong password" do
    sign_in users(:bob)
    get :delete
    assert_response :success
    assert_no_difference 'User.count' do
      delete :destroy, :user => { :current_password => 'wrongpassword' }
    end
  end

  test "should destroy user with right password" do
    sign_in users(:bob)
    get :delete
    assert_response :success
    assert_difference 'User.count', -1 do
      delete :destroy, :user => { :current_password => 'password' }
    end
  end
end