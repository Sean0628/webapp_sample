# frozen_string_literal: true

# This class is responsible for notifying an external service about an edit request.
class EditRequestNotifier
  def self.notify(edit_request)
    new(edit_request).notify
  end

  def initialize(edit_request)
    @edit_request = edit_request
  end

  # In the real application, this method would notify an external service
  # but here we create data in the tables for simplicity.
  def notify # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    ActiveRecord::Base.transaction do
      external_request = ExternalEditRequest.create!(
        external_issuer_id: edit_request.issuer.external_id,
        status: 0 # Pending
      )

      edit_request.edit_request_details.each do |detail|
        ExternalEditRequestDetail.create!(
          external_edit_request_id: external_request.id,
          field_name: detail.field_name,
          old_value: detail.old_value,
          new_value: detail.new_value,
          associated_record_id: detail.external_id,
          associated_record_type: detail.external_type.camelize
        )
      end

      edit_request.update!(external_id: external_request.id)
    end
  end

  private

  attr_reader :edit_request
end
