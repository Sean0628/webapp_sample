# frozen_string_literal: true

class ExternalEditRequest < ApplicationRecord # :nodoc:
  belongs_to :external_issuer
  has_many :external_edit_request_details, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_update :process_status_change, if: :saved_change_to_status?
  after_commit :notify_external_edit_request, on: :update, if: :saved_change_to_status?

  private

  # TODO: This can be processed in a background job
  def process_status_change
    External::RecordsUpdater.update(external_edit_request_details) if approved?
  end

  def notify_external_edit_request
    # In the real application, we would notify the external system via a webhook or some other mechanism
    # in a background job. For the sake of simplicity, we will just call the method directly.
    External::EditRequestNotifier.notify(self)
  end
end
