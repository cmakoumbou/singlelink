class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@user = current_user
  end

  def create
		token = params[:stripeToken]
		customer_email = params[:stripeEmail]

		customer = Stripe::Customer.create(
			:source => token,
			:plan => "1",
			:email => customer_email
		)

  rescue Stripe::CardError => e
  	flash[:error] = e.message
  	redirect_to subscriptions_path
  end

  def cancel
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    customer.subscriptions.retrieve(@user_subscription.subscription_id).delete(:at_period_end => true)
    redirect_to root_url, notice: 'Subscription was successfully cancelled.'
  end

  def resume
    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = @user_subscription.plan_id
    subscription.save
    redirect_to root_url, notice: 'Subscription was successfully resumed.'
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
  end
end
