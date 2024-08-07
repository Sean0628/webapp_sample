# frozen_string_literal: true

FactoryBot.define do
  factory :edit_request do
    issuer
    status { :pending }
  end
end
