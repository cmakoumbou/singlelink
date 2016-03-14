class AddTextColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :text_colour, :string
  end
end
