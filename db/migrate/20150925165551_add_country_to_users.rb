class AddCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string, null: false, default: "GB"
  end
end
