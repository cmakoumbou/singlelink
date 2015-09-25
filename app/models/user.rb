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
#  admin                  :boolean          default(FALSE)
#  country                :string           default("GB"), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :links, dependent: :destroy

  extend FriendlyId
  friendly_id :username

  after_validation :move_friendly_id_error_to_name
         
  VALID_USERNAME_REGEX = /\A[a-z0-9]+\z/i
	validates :username, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false },
		format: { with: VALID_USERNAME_REGEX, message: "is invalid (only letters and numbers allowed)"}

  validates :display_name, length: { maximum: 25 }
  validates :bio, length: { maximum: 160 }
  validates :country, presence: true

	private

	  def move_friendly_id_error_to_name
    	errors.add :name, *errors.delete(:friendly_id) if errors[:friendly_id].present?
    end
end
