# frozen_string_literal: true

class Address < ApplicationRecord # :nodoc:
  include ExternalAssociable

  belongs_to :issuer
  belongs_to :country
  belongs_to :province

  enum address_type: { company: 0, billing: 1, mailing: 2 }

  validates :issuer, :country, :province, :city, :address, :zip_code, presence: true
end
