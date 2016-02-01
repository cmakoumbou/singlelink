Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

if ENV.has_key?("STRIPE_WEBHOOK_SECRET")
  StripeEvent.authentication_secret = ENV['STRIPE_WEBHOOK_SECRET']
end

StripeEvent.configure do |events|
	events.subscribe 'invoice.payment_succeeded' do |event|
		customer = Stripe::Customer.retrieve(event.data.object.customer)
		sub = customer.subscriptions.retrieve(event.data.object.subscription)
		renew_subscription = Subscription.find_by_customer_id(event.data.object.customer)

		if renew_subscription.blank?
			user = User.find_by_email(customer.email)
			new_subscription = Subscription.find_by_user_id(user.id)
			new_subscription.update(subscription_id: sub.id, customer_id: sub.customer, plan_id: sub.plan.id,
			 user: user, start_date: Time.at(sub.current_period_start), end_date: Time.at(sub.current_period_end),
			 last4: customer.sources.data.last.last4, status: "active")
		else
			renew_subscription.update(subscription_id: sub.id, plan_id: sub.plan.id, start_date: Time.at(sub.current_period_start), 
				end_date: Time.at(sub.current_period_end), status: "active")
		end
	end

	events.subscribe 'invoice.payment_failed' do |event|
		next_payment_attempt = event.data.object.next_payment_attempt
		if next_payment_attempt.present?
			attempt_count = event.data.object.attempt_count
			user_subscription = Subscription.find_by_customer_id(event.data.object.customer)
			user = User.find_by_id(user_subscription.user_id)
			user_subscription.status = "past_due"
			user_subscription.next_payment_attempt = Time.at(event.data.object.next_payment_attempt)
			user_subscription.save
			UserMailer.failed_payment(user, next_payment_attempt, attempt_count).deliver
		end
	end

	events.subscribe 'customer.subscription.deleted' do |event|
		user_subscription = Subscription.find_by_customer_id(event.data.object.customer)
		if user_subscription.present?
			user = User.find_by_id(user_subscription.user_id)
			user_subscription.status = "canceled"
			user_subscription.save
			user.links.update_all(:disable => true)
			UserMailer.cancel_subscription(user).deliver
		end
	end

	events.subscribe 'customer.source.created' do |event|
		user_subscription = Subscription.find_by_customer_id(event.data.object.customer)
		if user_subscription.present?
			user_subscription.last4 = event.data.object.last4
			user_subscription.save
		end
	end

	events.subscribe 'customer.subscription.trial_will_end' do |event|
		user_subscription = Subscription.find_by_customer_id(event.data.object.customer)
		if user_subscription.present?
			user = User.find_by_id(user_subscription.user_id)
			UserMailer.trial_ending(user).deliver
		end
	end
end