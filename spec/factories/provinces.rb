# frozen_string_literal: true

FactoryBot.define do
  factory :province do
    sequence(:name) { |n| "Province #{n}" }
  end
end
