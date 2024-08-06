class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :issuer, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.string :city, null: false
      t.string :address, null: false
      t.string :zip_code, null: false
      t.integer :address_type, null: false, default: 0 # 0: company

      t.timestamps
    end
  end
end
