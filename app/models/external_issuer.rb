# frozen_string_literal: true

class ExternalIssuer < ApplicationRecord # :nodoc:
  belongs_to :external_industry
  has_one :external_company_link, dependent: :destroy
  has_many :external_addresses, dependent: :destroy
  has_many :external_security_details, dependent: :destroy

  validates :name_en, :name_fr, :external_industry, :financial_year_end, presence: true
end
