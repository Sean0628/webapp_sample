class CreateSecurityDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :security_details do |t|
      t.references :issuer, null: false, foreign_key: true
      t.string :name_en, null: false
      t.string :name_fr, null: false
      t.integer :issue_outstanding, null: false, default: 0
      t.integer :reserved_for_issuance, null: false, default: 0
      t.integer :total_equity_shares_as_if_converted, null: false, default: 0

      t.timestamps
    end
  end
end
