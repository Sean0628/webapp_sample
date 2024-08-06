# frozen_string_literal: true

class EditRequest < ApplicationRecord # :nodoc:
  belongs_to :issuer
  has_many :edit_request_fields, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
