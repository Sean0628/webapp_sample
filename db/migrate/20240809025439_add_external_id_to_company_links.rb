class AddExternalIdToCompanyLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :company_links, :external_id, :integer, null: false
    add_index :company_links, :external_id, unique: true
  end
end
