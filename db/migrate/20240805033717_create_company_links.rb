class CreateCompanyLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :company_links do |t|
      t.references :issuer, null: false, foreign_key: true
      t.string :linkedin_url
      t.string :youtube_url
      t.string :instagram_url

      t.timestamps
    end
  end
end
