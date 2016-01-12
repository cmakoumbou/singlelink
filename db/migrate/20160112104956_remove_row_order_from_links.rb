class RemoveRowOrderFromLinks < ActiveRecord::Migration
  def change
  	remove_column :links, :row_order, :integer
  end
end