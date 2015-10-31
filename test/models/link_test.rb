# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  row_order  :integer
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase

	def setup

		# User 1 with 5 links
		@user = FactoryGirl.create(:user)
		@link = FactoryGirl.create(:link, user: @user)
		@link2 = FactoryGirl.create(:link, user: @user)
		@link3 = FactoryGirl.create(:link, user: @user)
		@link4 = FactoryGirl.create(:link, user: @user)
		@link5 = FactoryGirl.create(:link, user: @user)

		# User 2 with 0 link
		@user2 = FactoryGirl.create(:user)

		# User 3 with 7 links and a pro subscription
		@user3 = FactoryGirl.create(:user, plan: 1, plan_ending: Time.now + 7.days)
		@link_user3 = FactoryGirl.create(:link, user: @user3)
		@link2_user3 = FactoryGirl.create(:link, user: @user3)
		@link3_user3 = FactoryGirl.create(:link, user: @user3)
		@link4_user3 = FactoryGirl.create(:link, user: @user3)
		@link5_user3 = FactoryGirl.create(:link, user: @user3)
		@link6_user3 = FactoryGirl.create(:link, user: @user3)
		@link7_user3 = FactoryGirl.create(:link, user: @user3)

		# User 4 with 12 links and a business subscription
		@user4 = FactoryGirl.create(:user, plan: 2, plan_ending: Time.now + 7.days)
		@link_user4 = FactoryGirl.create(:link, user: @user4)
		@link2_user4 = FactoryGirl.create(:link, user: @user4)
		@link3_user4 = FactoryGirl.create(:link, user: @user4)
		@link4_user4 = FactoryGirl.create(:link, user: @user4)
		@link5_user4 = FactoryGirl.create(:link, user: @user4)
		@link6_user4 = FactoryGirl.create(:link, user: @user4)
		@link7_user4 = FactoryGirl.create(:link, user: @user4)
		@link8_user4 = FactoryGirl.create(:link, user: @user4)
		@link9_user4 = FactoryGirl.create(:link, user: @user4)
		@link10_user4 = FactoryGirl.create(:link, user: @user4)
		@link11_user4 = FactoryGirl.create(:link, user: @user4)
		@link12_user4 = FactoryGirl.create(:link, user: @user4)
	end

	test "should be valid" do
		assert @link.valid?
	end

	test "user id should be present" do
		@link.user_id = nil
		assert_not @link.valid?
	end

	test "url should be present" do
		@link.url = " "
		assert_not @link.valid?
	end

	test "url validation should accept valid urls" do
  	valid_urls = %w[http://www.facebook.com www.twitter.com http://www.instagram.com google.com]

  	valid_urls.each do |valid_url|
  		@link.url = valid_url
  		assert @link.valid?, "#{valid_url.inspect} should be valid"
  	end
  end

  test "url validation should reject invalid urls" do
  	invalid_urls = %w[htt://www.website.com http://example.com. www.vsdfbdfsbsdfbsdnflbs random]

  	invalid_urls.each do |invalid_url|
  		@link.url = invalid_url
  		assert_not @link.valid?, "#{invalid_url.inspect} should be invalid"
  	end
  end

  test "links plan limit when 0 link already present" do
  	@link_limit_user2 = Link.new(url: "google.com", user: @user2)
  	assert @link_limit_user2.valid?
  end

  test "links plan limit when 5 links already present and no subscription" do
  	@link_limit = Link.new(url: "google.com", user: @user)
  	assert_not @link_limit.valid?
  end

  test "links plan limit when 7 links already present and pro subscription" do
  	@link_limit_user3 = Link.new(url: "google.com", user: @user3)
  	assert @link_limit_user3.valid?
  end

  test "links plan limit when 12 links already present and business subscription" do
  	@link_limit_user4 = Link.new(url: "google.com", user: @user4)
  	assert @link_limit_user4.valid?
  end
end
