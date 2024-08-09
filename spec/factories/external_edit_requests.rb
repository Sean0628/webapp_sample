# frozen_string_literal: true

FactoryBot.define do
  factory :external_edit_request do
    external_issuer
    status { :pending }
  end
end
