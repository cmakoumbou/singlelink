class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_name, :string
    add_column :users, :bio, :string
  end
end
