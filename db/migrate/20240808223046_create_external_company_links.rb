class CreateExternalCompanyLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :external_company_links do |t|
      t.references :external_issuer, null: false, foreign_key: true
      t.string :linkedin_url
      t.string :youtube_url
      t.string :instagram_url

      t.timestamps
    end
  end
end
