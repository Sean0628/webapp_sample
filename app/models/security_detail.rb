# frozen_string_literal: true

class SecurityDetail < ApplicationRecord # :nodoc:
  belongs_to :issuer

  validates :name_en, :name_fr, :issue_outstanding, :reserved_for_issuance, :total_equity_shares_as_if_converted,
            presence: true
  validates :issue_outstanding, :reserved_for_issuance, :total_equity_shares_as_if_converted,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
