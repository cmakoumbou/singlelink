class AddNameColourToCards < ActiveRecord::Migration
  def change
    add_column :cards, :name_colour, :string
  end
end
