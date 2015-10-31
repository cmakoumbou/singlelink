# This will guess the User class
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password "password"
    password_confirmation "password"
    # country "GB"
    # time_zone "London"
  end

  factory :link do
    url "http://www.google.com"
    row_order "8228045"
    user
  end

  factory :subscription, :class => 'Payola::Subscription' do
    plan_type "SubscriptionPlan"
    plan_id 1
    start nil
    status nil
    owner_type "User"
    owner_id 1
    stripe_customer_id "random_customer_id"
    cancel_at_period_end false
    current_period_start Time.now
    current_period_end Time.now + 7.days
    ended_at nil
    trial_start nil
    trial_end nil
    canceled_at nil
    quantity 1
    stripe_id "random_stripe_id"
    stripe_token "random_stripe_token"
    card_last4 "4242"
    card_expiration (Time.now + 2.years).strftime("%Y-%m-%d")
    card_type "Visa"
    email "user@example.com"
    currency "gbp"
    amount 499
  end
end