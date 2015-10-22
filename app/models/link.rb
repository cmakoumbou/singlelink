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

class Link < ActiveRecord::Base
  belongs_to :user
  before_save :smart_add_url_protocol

  include RankedModel
  ranks :row_order
  
  validates :url, :url => { :message => "is not valid" }
  validates_presence_of :user
  validate :links_plan_limit, on: :create

  def links_plan_limit
  	if self.user.plan == 0
  		if self.user.links(:reload).count >= 5
  			errors.add(:base, 'Exceeded links limit')
  		end
  	elsif self.user.plan == 1
  		if self.user.links(:reload).count >= 10
  			errors.add(:base, 'Exceeded links limit')
  		end
    elsif self.user.plan == 2
    	if self.user.links(:reload).count >= 25
  			errors.add(:base, 'Exceeded links limit')
  		end
    end
  end

  protected
	  def smart_add_url_protocol
	  	if self.url.present?
	  		unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
	    		self.url = "http://#{self.url}"
	  		end
	  	end
		end
end
