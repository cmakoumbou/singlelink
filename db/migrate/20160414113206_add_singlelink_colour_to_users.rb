class AddSinglelinkColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :singlelink_colour, :string
  end
end
