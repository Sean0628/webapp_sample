# frozen_string_literal: true

class ExternalSecurityDetail < ApplicationRecord # :nodoc:
  belongs_to :external_issuer

  validates :external_issuer, :name_en, :name_fr, :issue_outstanding, :reserved_for_issuance,
            :total_equity_shares_as_if_converted, presence: true
  validates :issue_outstanding, :reserved_for_issuance, :total_equity_shares_as_if_converted,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
