class AddNameColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name_colour, :string
  end
end
