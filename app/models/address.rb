# frozen_string_literal: true

class Address < ApplicationRecord # :nodoc:
  belongs_to :issuer
  belongs_to :country
  belongs_to :province

  enum address_type: { company: 0, billing: 1, mailing: 2 }

  validates :issuer_id, :country_id, :province_id, :city, :address, :zip_code, presence: true
end
