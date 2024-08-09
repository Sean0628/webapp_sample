class CreateExternalIssuers < ActiveRecord::Migration[7.0]
  def change
    create_table :external_issuers do |t|
      t.string :name_en, null: false
      t.string :name_fr, null: false
      t.text :description_en
      t.text :description_fr
      t.string :logo_url
      t.references :external_industry, null: false, foreign_key: true
      t.date :financial_year_end

      t.timestamps
    end
  end
end
