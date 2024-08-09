# frozen_string_literal: true

FactoryBot.define do
  factory :external_industry do
    sequence(:name) { |n| "Industry #{n}" }
  end
end
