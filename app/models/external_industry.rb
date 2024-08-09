# frozen_string_literal: true

class ExternalIndustry < ApplicationRecord # :nodoc:
  has_many :external_issuers, dependent: :restrict_with_error
end
