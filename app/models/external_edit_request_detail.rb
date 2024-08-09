# frozen_string_literal: true

class ExternalEditRequestDetail < ApplicationRecord # :nodoc:
  FIELD_MAP = {
    name_en: 0,
    name_fr: 1,
    description_en: 2,
    description_fr: 3,
    logo_url: 4,
    industry_id: 5,
    financial_year_end: 6,
    linkedin_url: 7,
    youtube_url: 8,
    instagram_url: 9,
    country_id: 10,
    address: 11,
    city: 12,
    province_id: 13,
    zip_code: 14,
    issue_outstanding: 15,
    reserved_for_issuance: 16,
    total_equity_shares_as_if_converted: 17
  }.freeze

  belongs_to :external_edit_request
  belongs_to :associated_record, polymorphic: true

  enum field_name: FIELD_MAP
end
