class AddLinkColourToUsers < ActiveRecord::Migration
  def change
    add_column :users, :link_colour, :string
  end
end
