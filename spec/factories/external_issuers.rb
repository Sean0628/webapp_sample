# frozen_string_literal: true

FactoryBot.define do
  factory :external_issuer do
    sequence(:name_en) { |n| "Issuer #{n}" }
    sequence(:name_fr) { |n| "Emetteur #{n}" }
    description_en { 'MyText' }
    description_fr { 'MyText' }
    logo_url { 'MyString' }
    external_industry
    financial_year_end { Date.today }
  end
end
