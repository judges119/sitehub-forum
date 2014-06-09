class AddEditedByToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :edited_by_id, :integer
  end
end
