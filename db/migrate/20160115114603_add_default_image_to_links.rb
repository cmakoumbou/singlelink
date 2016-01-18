class AddDefaultImageToLinks < ActiveRecord::Migration
  def change
    add_column :links, :default_image, :string
  end
end
