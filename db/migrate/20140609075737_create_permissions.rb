class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :forum_id
      t.integer :group_id
      t.boolean :can_post

      t.timestamps
    end
  end
end
