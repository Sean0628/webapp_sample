class AddExternalIdToSecurityDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :security_details, :external_id, :integer, null: false
    add_index :security_details, :external_id, unique: true
  end
end
