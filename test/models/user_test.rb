# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  display_name           :string
#  bio                    :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
    @user = User.new(username: "example", email: "example@company.com", password: "superlol", password_confirmation: "superlol")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
  	@user.username = " "
  	assert_not @user.valid?
  end

  test "username should not be too long" do
  	@user.username = "a" * 50
  	assert_not @user.valid?
  end

  test "username validation should accept valid usernames" do
  	valid_usernames = %w[example example123 123456789]

  	valid_usernames.each do |valid_username|
  		@user.username = valid_username
  		assert @user.valid?, "#{valid_username.inspect} should be valid"
  	end
  end

  test "username validation should reject invalid usernames" do
  	invalid_usernames = %w[exam_ple example-1 123+456789]

  	invalid_usernames.each do |invalid_username|
  		@user.username = invalid_username
  		assert_not @user.valid?, "#{invalid_username.inspect} should be invalid"
  	end
  end

  test "username should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.username = @user.username.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "display_name should not be too long" do
  	@user.display_name = "a" * 50
  	assert_not @user.valid?
  end

  test "bio should not be too long" do
  	@user.bio = "a" * 170
  	assert_not @user.valid?
  end
end
