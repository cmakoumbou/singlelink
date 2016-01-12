# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  disable    :boolean          default(FALSE)
#  title      :string
#  image      :string
#  position   :integer
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase

	def setup
		@user = users(:bob)
		@link = Link.new(url: "http://www.google.com", user_id: @user.id)
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

end
