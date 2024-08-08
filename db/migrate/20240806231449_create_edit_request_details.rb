class CreateEditRequestDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :edit_request_details do |t|
      t.references :edit_request, null: false, foreign_key: true
      t.integer :field_name, null: false, default: 0
      t.string :old_value
      t.string :new_value
      t.integer :associated_record_id, null: false
      t.string :associated_record_type, null: false

      t.timestamps
    end

    add_index :edit_request_details, %i[associated_record_id associated_record_type],
              name: 'index_edit_request_details_on_associated_record'
  end
end
