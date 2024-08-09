# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    issuer
    country
    province
    sequence(:external_id)
    address { '123 Example St' }
    city { 'Example City' }
    zip_code { '12345' }
    address_type { :company } # or :billing, :mailing depending on the context

    factory :company_address do
      address_type { :company }
    end

    factory :billing_address do
      address_type { :billing }
    end

    factory :mailing_address do
      address_type { :mailing }
    end
  end
end
