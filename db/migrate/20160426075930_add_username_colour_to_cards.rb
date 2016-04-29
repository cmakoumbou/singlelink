class AddUsernameColourToCards < ActiveRecord::Migration
  def change
    add_column :cards, :username_colour, :string
  end
end
