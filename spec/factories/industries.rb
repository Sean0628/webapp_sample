# frozen_string_literal: true

FactoryBot.define do
  factory :industry do
    sequence(:name) { |n| "Industry #{n}" }
  end
end
