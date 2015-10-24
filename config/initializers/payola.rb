Payola.configure do |config|
  # Example subscription:
  # 
  # config.subscribe 'payola.package.sale.finished' do |sale|
  #   EmailSender.send_an_email(sale.email)
  # end
  # 
  # In addition to any event that Stripe sends, you can subscribe
  # to the following special payola events:
  #
  #  - payola.<sellable class>.sale.finished
  #  - payola.<sellable class>.sale.refunded
  #  - payola.<sellable class>.sale.failed
  #
  # These events consume a Payola::Sale, not a Stripe::Event
  #
  # Example charge verifier:
  #
  # config.charge_verifier = lambda do |sale|
  #   raise "Nope!" if sale.email.includes?('yahoo.com')
  # end

  # Keep this subscription unless you want to disable refund handling
  config.subscribe 'charge.refunded' do |event|
    sale = Payola::Sale.find_by(stripe_id: event.data.object.id)
    sale.refund!
  end

  config.secret_key = 'sk_test_ATsPjXiIY9SEMfGwrciEX2FI'
  config.publishable_key = 'pk_test_eGtqOr9oXqXZN6IFAfG6plW6'

  config.background_worker = :sidekiq

  config.default_currency = 'gbp'

  config.subscribe('payola.subscription.active') do |sub|
    user = User.find_by(email: sub.email)
    sub.owner = user
    sub.save!
  end

  config.subscribe 'customer.subscription.created' do |event|
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    user = User.find_by(email: subscription.email)
    user.plan = subscription.plan_id
    user.plan_ending = subscription.current_period_end
    user.save!
  end

  config.subscribe 'customer.subscription.deleted' do |event|
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    user = User.find_by(email: subscription.email)
    user.plan_ending = subscription.current_period_end
    user.save!
  end

  config.subscribe 'customer.subscription.updated' do |event|
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    user = User.find_by(email: subscription.email)
    user.plan = subscription.plan_id
    user.plan_ending = subscription.current_period_end
    user.save!
  end
end
