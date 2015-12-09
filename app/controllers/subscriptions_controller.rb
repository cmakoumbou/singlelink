class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

  # Subscriptions Index

  def index
  	@user = current_user
    @user_subscription = @user.subscriptions.take
  end

  # Pro Subscription

  def pro
    authorize! :pro, Subscription

    @user = current_user
  end

  def pro_confirm
    authorize! :pro_confirm, Subscription

    @user = current_user

    if @user.subscriptions.present?
      token = params[:stripeToken]
      customer = Stripe::Customer.retrieve(@user.subscriptions.take.customer_id)
      customer.subscriptions.create(:source => token, :plan => "1")
    else
      token = params[:stripeToken]
      customer_email = params[:stripeEmail]
      customer = Stripe::Customer.create(:source => token, :plan => "1", :email => customer_email, :trial_end => 1449580848)
    end

    redirect_to root_url, notice: 'Pro Subscription was successfully activated.'

  rescue => e
    flash[:error] = e.message
    redirect_to pro_subscription_path
  end

  # Cancel Subscription

  def cancel
    authorize! :cancel, Subscription
  end

  def cancel_confirm
    authorize! :cancel_confirm, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take
    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)

    if @user_subscription.status == "active" && @user_subscription.end_date > Time.now
      customer.subscriptions.retrieve(@user_subscription.subscription_id).delete(:at_period_end => true)
    else
      customer.subscriptions.retrieve(@user_subscription.subscription_id).delete
    end
    
    @user_subscription.status = "canceled"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully canceled.'

  rescue => e
    flash[:error] = e.message
    redirect_to cancel_subscription_path
  end

  # Resume Subscription

  def resume
    authorize! :resume, Subscription
  end

  def resume_confirm
    authorize! :resume_confirm, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = subscription.plan.id
    subscription.save

    @user_subscription.status = "active"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully resumed.'

  rescue => e
    flash[:error] = e.message
    redirect_to resume_subscription_path
  end

  # Card Subscription

  def card
    authorize! :card, Subscription

    @user = current_user
  end

  def card_update
    authorize! :card_update, Subscription

    token = params[:stripeToken]
    @user = current_user
    @user_subscription = @user.subscriptions.take

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    customer.source = token
    customer.save
    redirect_to root_url, notice: 'Card was successfully updated.'

  rescue => e
    flash[:error] = e.message
    redirect_to card_subscription_path
  end
end