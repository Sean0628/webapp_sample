# frozen_string_literal: true

FactoryBot.define do
  factory :external_edit_request_detail do
    external_edit_request
    field_name { 0 } # :name_en
    old_value { 'Old Value' }
    new_value { 'New Value' }
    associated_record_id { 1 }
    associated_record_type { 'Issuer' }
  end
end
