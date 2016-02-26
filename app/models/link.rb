# == Schema Information
#
# Table name: links
#
#  id            :integer          not null, primary key
#  url           :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  disable       :boolean          default(FALSE)
#  title         :string
#  image         :string
#  position      :integer
#  default_image :string
#

class Link < ActiveRecord::Base
  acts_as_list add_new_at: :bottom

  mount_uploader :image, ImageUploader
  
  belongs_to :user
  before_save :smart_add_url_protocol
  
  validates :title, length: { maximum: 12}, presence: true
  validates :url, :url => { :message => "is not valid" }
  validates_presence_of :user
  validates :image, file_size: { less_than: 2.megabytes, message: 'link image should be less than %{count}' }


  rails_admin do
    list do
      field :title
      field :url
      field :user
    end
    show do
      field :title
      field :url
      field :user
      field :image
      field :default_image
    end
    edit do
      field :title
      field :url
      field :user
      field :image
      field :default_image
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
