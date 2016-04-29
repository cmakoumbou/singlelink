class AddLogoToCards < ActiveRecord::Migration
  def change
    add_column :cards, :logo, :string
  end
end
