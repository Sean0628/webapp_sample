# frozen_string_literal: true

class ExternalCountry < ApplicationRecord # :nodoc:
  has_many :external_issuers, dependent: :restrict_with_error
end
