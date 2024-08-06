class CreateEditRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :edit_requests do |t|
      t.references :issuer, null: false, foreign_key: true
      t.integer :status, null: false, default: 0 # 0: pending

      t.timestamps
    end
  end
end
