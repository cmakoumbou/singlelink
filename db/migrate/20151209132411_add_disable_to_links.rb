class AddDisableToLinks < ActiveRecord::Migration
  def change
    add_column :links, :disable, :boolean, default: false
  end
end
