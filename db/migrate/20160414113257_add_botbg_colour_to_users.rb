class AddBotbgColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :botbg_colour, :string
  end
end
