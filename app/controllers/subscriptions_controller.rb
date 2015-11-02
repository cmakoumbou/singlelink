class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@user = current_user
  end

  def create
  	# @amount = 499

  	# customer = Stripe::Customer.create(
  	# 	:email => params[:stripeEmail],
  	# 	:card => params[:stripeToken]
  	# )

  	# charge = Stripe::Charge.create(
  	# 	:customer => customer.id,
  	# 	:amount => @amount,
  	# 	:description => 'Rails Stripe Customer',
  	# 	:currency => 'gbp'
  	# )

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

end
