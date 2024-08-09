class AddExternalIdToEditRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :edit_requests, :external_id, :integer
    add_index :edit_requests, :external_id, unique: true
  end
end
