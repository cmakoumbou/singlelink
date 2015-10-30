class SubscriptionsController < ApplicationController
	before_action :authenticate_user!, except: [:pricing]
	before_action :subscribed_user, only: [:index]
	before_action :non_subscribed_user, only: [:pricing]

  def index
  	@subscription = Payola::Subscription.where(owner_id: current_user.id).last
  	@subscription_guid = @subscription.guid
  	@pro_plan = SubscriptionPlan.first
  	@business_plan = SubscriptionPlan.second
  end

  def pricing
    @pro_plan = SubscriptionPlan.first
    @business_plan = SubscriptionPlan.second
  end

  private
    def subscribed_user
      redirect_to pricing_url, alert: 'You are not subscribed to a plan' unless user_subscribed?
    end

    def non_subscribed_user
    	if user_signed_in?
    		redirect_to subscription_url unless !user_subscribed?
    	end
    end
end


