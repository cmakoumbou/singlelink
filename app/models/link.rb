# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Link < ActiveRecord::Base
  belongs_to :user
  before_save :smart_add_url_protocol
  validates :url, :url => { :message => "is not valid" }
  validates_presence_of :user

  protected
	  def smart_add_url_protocol
	  	if self.url.present?
	  		unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
	    		self.url = "http://#{self.url}"
	  		end
	  	end
		end
end
