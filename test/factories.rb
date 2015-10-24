# This will guess the User class
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password "password"
    password_confirmation "password"
    country "GB"
    time_zone "London"
  end

  factory :link do
    url "http://www.google.com"
    row_order "8228045"
    user
  end

  factory :subscription, :class => 'Payola::Subscription' do
    plan_type "SubscriptionPlan"
    plan_id 1
    start "2014-11-04 22:34:39"
    status "MyString"
    owner_type "Owner"
    owner_id 1
    cancel_at_period_end false
    current_period_start "2014-11-04 22:34:39"
    current_period_end "2014-11-04 22:34:39"
    ended_at "2014-11-04 22:34:39"
    trial_start Time.now
    trial_end Time.now + 7.days
    canceled_at "2014-11-04 22:34:39"
    email "jeremy@octolabs.com"
    stripe_token "yyz123"
    currency 'usd'
    quantity 1
    stripe_id 'sub_123456'
  end
end