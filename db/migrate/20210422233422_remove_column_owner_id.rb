class RemoveColumnOwnerId < ActiveRecord::Migration[6.1]
  def change
    remove_column :pets, :owner_id
  end
end
