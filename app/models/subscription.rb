# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer          not null, primary key
#  subscription_id :string
#  customer_id     :string
#  plan_id         :string
#  user_id         :integer
#  end_date        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  start_date      :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :user
end
