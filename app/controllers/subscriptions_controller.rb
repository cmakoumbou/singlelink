class SubscriptionsController < ApplicationController
  def index
  end

  def cancel
  end

  def change
  end

  def card
  	@info = Payola::Subscription.where(owner_id: current_user.id).last.guid
  end
end
