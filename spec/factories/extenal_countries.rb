# frozen_string_literal: true

FactoryBot.define do
  factory :external_country do
    sequence(:name) { |n| "Country #{n}" }
  end
end
