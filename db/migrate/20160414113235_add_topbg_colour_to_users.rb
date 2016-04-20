class AddTopbgColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :topbg_colour, :string
  end
end
