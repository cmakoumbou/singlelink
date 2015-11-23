Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
	events.subscribe 'invoice.payment_succeeded' do |event|
		customer = Stripe::Customer.retrieve(event.data.object.customer)
		sub = customer.subscriptions.retrieve(event.data.object.subscription)

		user_subscription = Subscription.find_by_subscription_id(sub.id)

		if user_subscription.blank?
			user = User.find_by_email(customer.email)
			subscription = Subscription.new do |s|
				s.subscription_id = sub.id
				s.customer_id = sub.customer
				s.plan_id = sub.plan.id
				s.user = user
				s.start_date = Time.at(sub.current_period_start)
				s.end_date = Time.at(sub.current_period_end)
				s.status = "active"
			end
			subscription.save
		else
			user_subscription.plan_id = sub.plan.id
			user_subscription.start_date = Time.at(sub.current_period_start)
			user_subscription.end_date = Time.at(sub.current_period_end)
			user_subscription.status = "active"
			user_subscription.save
		end
	end

	events.subscribe 'invoice.payment_failed' do |event|
		customer = Stripe::Customer.retrieve(event.data.object.customer)
		invoice = Stripe::Invoice.retrieve(event.data.object.id)

		# user_subscription = Subscription.find_by_subscription_id(invoice.subscription)
		# user = User.find_by_id(user_subscription.user_id)

		user_subscription = Subscription.find_by_id(1)
		user = User.find_by_id(1)

		next_payment_attempt = invoice.next_payment_attempt
		attempt_count = invoice.attempt_count

		if next_payment_attempt.blank?
			user_subscription.status = "cancelled"
		else
			user_subscription.status = "past_due"
		end
		user_subscription.save
		
		UserMailer.failed_payment(user, next_payment_attempt, attempt_count).deliver
	end
end