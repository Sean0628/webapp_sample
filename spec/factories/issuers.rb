# frozen_string_literal: true

FactoryBot.define do
  factory :issuer do
    sequence(:external_id)
    sequence(:name_en) { |n| "Issuer #{n}" }
    sequence(:name_fr) { |n| "Emetteur #{n}" }
    description_en { 'MyText' }
    description_fr { 'MyText' }
    logo_url { 'MyString' }
    association :industry
    financial_year_end { Date.today }
  end
end
