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

    proration_date = Time.now.to_i
    invoice = Stripe::Invoice.upcoming(
      :customer => @user_subscription.customer_id, 
      :subscription => @user_subscription.subscription_id,
      :subscription_plan => "2", 
      :subscription_proration_date => proration_date
    )

    current_prorations = invoice.lines.data.select { |ii| ii.period.start == proration_date }

    @prorated_charge = Money.new(current_prorations.first.amount, "GBP") + Money.new(current_prorations.second.amount, "GBP")
    @final_charge = @prorated_charge + Money.new(999, "GBP")
  end

  def downgrade
    @user = current_user
    @user_subscription = @user.subscriptions.last

    proration_date = Time.now.to_i
    invoice = Stripe::Invoice.upcoming(
      :customer => @user_subscription.customer_id, 
      :subscription => @user_subscription.subscription_id,
      :subscription_plan => "1", 
      :subscription_proration_date => proration_date
    )

    current_prorations = invoice.lines.data.select { |ii| ii.period.start == proration_date }

    @prorated_charge = Money.new(current_prorations.first.amount, "GBP") + Money.new(current_prorations.second.amount, "GBP")
    @final_charge = @prorated_charge.format(:sign_before_symbol => true)
    @lol = Money.new(current_prorations.first.amount, "GBP")
    @hello = Money.new(current_prorations.second.amount, "GBP")
  end

  def upgrade_confirm
    prorate_date = params[:prorate_date]
    prorate_date_int = prorate_date.to_i

    if (prorate_date_int + 3600) > Time.now.to_i
      proration_date = prorate_date.to_i
    else
      proration_date = Time.now.to_i
    end

    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = "2"
    subscription.proration_date = proration_date
    subscription.save

    @user_subscription.plan_id = "2"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully upgraded.'
  end

  def downgrade_confirm
    prorate_date = params[:prorate_date]
    prorate_date_int = prorate_date.to_i

    if (prorate_date_int + 3600) > Time.now.to_i
      proration_date = prorate_date.to_i
    else
      proration_date = Time.now.to_i
    end

    @user = current_user
    @user_subscription = @user.subscriptions.last

    customer = Stripe::Customer.retrieve(@user_subscription.customer_id)
    subscription = customer.subscriptions.retrieve(@user_subscription.subscription_id)
    subscription.plan = "1"
    subscription.proration_date = proration_date
    subscription.save

    @user_subscription.plan_id = "1"
    @user_subscription.save

    redirect_to root_url, notice: 'Subscription was successfully downgraded.'
  end
end
