class AddBannedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :banned, :boolean
  end
  
  def self.down
    remove_column :users, :banned
  end
end
