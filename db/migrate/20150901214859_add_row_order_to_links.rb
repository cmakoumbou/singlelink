class AddRowOrderToLinks < ActiveRecord::Migration
  def change
    add_column :links, :row_order, :integer
    add_index :links, :row_order
  end
end
