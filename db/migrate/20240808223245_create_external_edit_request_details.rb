class CreateExternalEditRequestDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :external_edit_request_details do |t|
      t.references :external_edit_request, null: false, foreign_key: true
      t.integer :field_name, null: false, default: 0
      t.string :old_value
      t.string :new_value
      t.integer :associated_record_id, null: false
      t.string :associated_record_type, null: false

      t.timestamps
    end

    add_index :external_edit_request_details, %i[associated_record_id associated_record_type],
              name: 'index_external_edit_request_details_on_associated_record'
  end
end
