class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :subscription_id
      t.string :customer_id
      t.string :plan_id
      t.references :user, index: true, foreign_key: true
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
