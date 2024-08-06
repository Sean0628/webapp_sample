# frozen_string_literal: true

class Province < ApplicationRecord # :nodoc:
  has_many :issuers, dependent: :restrict_with_error
end
