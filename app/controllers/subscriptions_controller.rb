class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@user = current_user
  end

  def pro
    @user = current_user
  end

  def business
    @user = current_user
  end

  def pro_confirm
    token = params[:stripeToken]
    customer_email = params[:stripeEmail]

    customer = Stripe::Customer.create(
      :source => token,
      :plan => "1",
      :email => customer_email
    )

    redirect_to root_url, notice: 'Pro Subscription was successfully activated.'

  rescue => e
    flash[:error] = e.message
    redirect_to pro_subscription_path
  end

  def business_confirm
    token = params[:stripeToken]
    customer_email = params[:stripeEmail]

    customer = Stripe::Customer.create(
      :source => token,
      :plan => "2",
      :email => customer_email
    )

    redirect_to root_url, notice: 'Business Subscription was successfully activated.'

  rescue => e
    flash[:error] = e.message
    redirect_to business_subscription_path
  end

  def cancel
  end

  def resume
  end

  def cancel_confirm
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    customer.subscriptions.retrieve(@user_subscription.subscription_id).delete(:at_period_end => true)
    redirect_to root_url, notice: 'Subscription was successfully cancelled.'
  rescue => e
    flash[:error] = e.message
    redirect_to cancel_subscription_path
  end

  def resume_confirm
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = @user_subscription.plan_id
    subscription.save
    redirect_to root_url, notice: 'Subscription was successfully resumed.'
  rescue => e
    flash[:error] = e.message
    redirect_to resume_subscription_path
  end

  def upgrade
    @user = current_user
    @user_subscription = @user.subscriptions.last
  end

  def downgrade
    @user = current_user
    @user_subscription = @user.subscriptions.last
  end

  def upgrade_confirm
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = "2"
    subscription.prorate = false
    subscription.save

    @user_subscription.plan_id = "2"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully upgraded.'
  rescue => e
    flash[:error] = e.message
    redirect_to upgrade_subscription_path
  end

  def downgrade_confirm
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = "1"
    subscription.prorate = false
    subscription.save

    redirect_to root_url, notice: 'Subscription was successfully downgraded.'

  rescue => e
    flash[:error] = e.message
    redirect_to downgrade_subscription_path
  end

  def card
    @user = current_user
  end

  def card_update
    token = params[:stripeToken]
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    customer.source = token
    customer.save
    redirect_to root_url, notice: 'Card was successfully updated.'

  rescue => e
    flash[:error] = e.message
    redirect_to card_subscription_path
  end
end
