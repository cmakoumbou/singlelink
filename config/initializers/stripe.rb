Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
	events.subscribe 'invoice.payment_succeeded' do |event|
		customer = Stripe::Customer.retrieve(event.data.object.customer)
		sub = customer.subscriptions.retrieve(event.data.object.subscription)

		user = User.find_by_email(customer.email)

		subscription = Subscription.new do |s|
			s.subscription_id = sub.id
			s.customer_id = sub.customer
			s.plan_id = sub.plan.id
			s.user = user
			s.end_date = Time.at(sub.current_period_end)
		end

		subscription.save!
	end
end