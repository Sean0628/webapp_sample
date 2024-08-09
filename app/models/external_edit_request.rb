# frozen_string_literal: true

class ExternalEditRequest < ApplicationRecord # :nodoc:
  belongs_to :external_issuer
  has_many :external_edit_request_fields, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_update :process_status_change, if: :saved_change_to_status?

  private

  def process_status_change
    External::RecordsUpdater.call(external_edit_details) if approved?
  end
end
