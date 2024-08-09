# frozen_string_literal: true

class EditRequest < ApplicationRecord # :nodoc:
  belongs_to :issuer
  has_many :edit_request_details, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }

  after_commit :notify_edit_request, on: :create

  def requested_fields
    edit_request_details.map(&:field_name)
  end

  private

  def notify_edit_request
    # In the real application, we would notify the external system via a webhook or some other mechanism
    # in a background job. For the sake of simplicity, we will just call the method directly.
    EditRequestNotifier.notify(self)
  end
end
