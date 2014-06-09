class AddModeratorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :moderator, :boolean, :default => false
  end
  
  def self.down
    remove_column :users, :admin
  end
end
