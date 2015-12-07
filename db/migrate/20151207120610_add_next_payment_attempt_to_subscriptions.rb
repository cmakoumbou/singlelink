class AddNextPaymentAttemptToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_payment_attempt, :datetime
  end
end
