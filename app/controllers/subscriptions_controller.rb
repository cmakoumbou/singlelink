class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@user = current_user
    @user_subscription = @user.subscriptions.take
  end

  def pro
    authorize! :pro, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take

    token = params[:stripeToken]
    customer_email = params[:stripeEmail]

    begin
      customer = Stripe::Customer.create(:source => token, :plan => "1", :email => customer_email)
      flash[:notice] = 'Welcome to your homepage!'
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to subscriptions_path
    rescue => e
      flash[:error] = "An error occurred while processing your card. Try again later."
      redirect_to subscriptions_path
    else
      subscription = Subscription.create(user: @user, status: "active")
      redirect_to root_url
    end
  end

  def renew
    authorize! :renew, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take

    token = params[:stripeToken]

    begin
      customer = Stripe::Customer.retrieve(@user.subscriptions.take.customer_id)
      customer.subscriptions.create(:source => token, :plan => "1")
      flash[:notice] = 'Subscription was successfully renewed.'
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to subscriptions_path
    rescue => e
      flash[:error] = "An error occurred while processing your card. Try again later."
      redirect_to subscriptions_path
    else
      @user_subscription.update(status: "active")
      redirect_to root_url
    end
  end

  def cancel
    authorize! :cancel, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take
    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)

    if @user_subscription.status == "active" && @user_subscription.end_date > Time.now
      customer.subscriptions.retrieve(@user_subscription.subscription_id).delete(:at_period_end => true)
    else
      customer.subscriptions.retrieve(@user_subscription.subscription_id).delete
      @user.links.update_all(:disable => true)
    end
    
    @user_subscription.status = "canceled"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully canceled.'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to subscriptions_path
  rescue => e
    flash[:error] = "An error occurred, try again later."
    redirect_to subscriptions_path
  end

  def resume
    authorize! :resume, Subscription

    @user = current_user
    @user_subscription = @user.subscriptions.take

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = subscription.plan.id
    subscription.save

    @user_subscription.status = "active"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully resumed.'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to subscriptions_path
  rescue => e
    flash[:error] = "An error occurred, try again later."
    redirect_to subscriptions_path
  end

  def card
    authorize! :card, Subscription

    token = params[:stripeToken]
    @user = current_user
    @user_subscription = @user.subscriptions.take

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    customer.source = token
    customer.save
    redirect_to root_url, notice: 'Card was successfully updated.'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to subscriptions_path
  rescue => e
    flash[:error] = "An error occurred, try again later."
    redirect_to subscriptions_path
  end
end