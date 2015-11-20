class AddEndDateExtentedToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :end_date_extended, :datetime
  end
end
