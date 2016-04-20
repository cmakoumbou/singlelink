class AddBioColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio_colour, :string
  end
end
