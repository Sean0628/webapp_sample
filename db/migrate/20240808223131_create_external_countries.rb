class CreateExternalCountries < ActiveRecord::Migration[7.0]
  def change
    create_table :external_countries do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
