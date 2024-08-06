# frozen_string_literal: true

class Country < ApplicationRecord # :nodoc:
  has_many :issuers, dependent: :restrict_with_error
end
