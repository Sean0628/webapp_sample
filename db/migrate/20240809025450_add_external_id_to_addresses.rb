class AddExternalIdToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :external_id, :integer, null: false
    add_index :addresses, :external_id, unique: true
  end
end
