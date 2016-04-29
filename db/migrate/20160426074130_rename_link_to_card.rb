class RenameLinkToCard < ActiveRecord::Migration
  def change
  	rename_table :links, :cards
  end
end
