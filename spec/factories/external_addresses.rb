# frozen_string_literal: true

FactoryBot.define do
  factory :external_address do
    external_issuer
    external_country
    external_province
    address { '123 Example St' }
    city { 'Example City' }
    zip_code { '12345' }
    address_type { :company } # or :billing, :mailing depending on the context

    factory :external_company_address do
      address_type { :company }
    end

    factory :external_billing_address do
      address_type { :billing }
    end

    factory :external_mailing_address do
      address_type { :mailing }
    end
  end
end
