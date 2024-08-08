# frozen_string_literal: true

FactoryBot.define do
  factory :security_detail do
    issuer
    name_en { 'Security Name EN' }
    name_fr { 'Security Name FR' }
    issue_outstanding { 1000 }
    reserved_for_issuance { 500 }
    total_equity_shares_as_if_converted { 1500 }
  end
end
