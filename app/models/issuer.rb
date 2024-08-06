# frozen_string_literal: true

class Issuer < ApplicationRecord # :nodoc:
  belongs_to :industry
  has_one :company_links, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :security_details, dependent: :destroy
  has_many :company_addresses, -> { where(address_type: :company) }, class_name: 'Address'
  has_many :billing_addresses, -> { where(address_type: :billing) }, class_name: 'Address'
  has_many :mailing_addresses, -> { where(address_type: :mailing) }, class_name: 'Address'

  validates :external_id, :name_en, :name_fr, :industry_id, :financial_year_end, presence: true
  validates :external_id, uniqueness: true
end
