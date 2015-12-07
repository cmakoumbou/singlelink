# == Schema Information
#
# Table name: subscriptions
#
#  id                   :integer          not null, primary key
#  subscription_id      :string
#  customer_id          :string
#  plan_id              :string
#  user_id              :integer
#  end_date             :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  start_date           :datetime
#  status               :string
#  last4                :string
#  next_payment_attempt :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :user

  def active?
  	if self.status == "active"
  		return true
  	else
  		return false
  	end
  end

  def past_due?
  	if self.status == "past_due"
  		return true
  	else
  		return false
  	end
  end

  def canceled_later?
    if self.status == "canceled" && self.end_date > Time.now
      return true
    else
      return false
    end
  end
end
