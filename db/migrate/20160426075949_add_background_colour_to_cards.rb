class AddBackgroundColourToCards < ActiveRecord::Migration
  def change
    add_column :cards, :background_colour, :string
  end
end
