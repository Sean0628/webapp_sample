# frozen_string_literal: true

FactoryBot.define do
  factory :edit_request_detail do
    edit_request
    field_name { :name_en }
    old_value { 'Old Value' }
    new_value { 'New Value' }
    associated_record_id { 1 }
    associated_record_type { 'Issuer' }
  end
end
