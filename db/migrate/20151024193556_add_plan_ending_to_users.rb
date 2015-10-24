class AddPlanEndingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan_ending, :datetime
  end
end
