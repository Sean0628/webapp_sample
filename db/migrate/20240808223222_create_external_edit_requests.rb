class CreateExternalEditRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :external_edit_requests do |t|
      t.references :external_issuer, null: false, foreign_key: true
      t.integer :status, null: false, default: 0 # 0: pending

      t.timestamps
    end
  end
end
