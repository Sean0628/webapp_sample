# frozen_string_literal: true

class EditRequest < ApplicationRecord # :nodoc:
  belongs_to :issuer
  has_many :edit_request_details, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }

  def requested_fields
    edit_request_details.map(&:field_name)
  end
end
