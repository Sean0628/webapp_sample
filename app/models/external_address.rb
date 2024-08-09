# frozen_string_literal: true

class ExternalAddress < ApplicationRecord # :nodoc:
  belongs_to :external_issuer
  belongs_to :external_country
  belongs_to :external_province

  enum address_type: { company: 0, billing: 1, mailing: 2 }

  validates :external_issuer, :external_country, :external_province, :city, :address, :zip_code, presence: true
end
