# frozen_string_literal: true

FactoryBot.define do
  factory :external_province do
    sequence(:name) { |n| "Province #{n}" }
  end
end
