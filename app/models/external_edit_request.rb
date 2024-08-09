# frozen_string_literal: true

class ExternalEditRequest < ApplicationRecord
  belongs_to :external_issuer
  has_many :external_edit_request_fields, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
