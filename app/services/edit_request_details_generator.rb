# frozen_string_literal: true

class EditRequestDetailsGenerator # :nodoc:
  def initialize(edit_request)
    @edit_request = edit_request
    @issuer = edit_request.issuer
    @record_created = false
  end

  def call(params) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    edit_request_details = []

    edit_request_details += check_associated_record_changes(@issuer, params)

    edit_request_details +=
      check_associated_record_changes(@issuer.company_link, params[:company_link_attributes])
    edit_request_details += check_associated_records_changes(@issuer.company_addresses,
                                                             params[:company_addresses_attributes])
    edit_request_details += check_associated_records_changes(@issuer.billing_addresses,
                                                             params[:billing_addresses_attributes])
    edit_request_details += check_associated_records_changes(@issuer.mailing_addresses,
                                                             params[:mailing_addresses_attributes])
    edit_request_details += check_associated_records_changes(@issuer.security_details,
                                                             params[:security_details_attributes])
    return unless edit_request_details.present?

    EditRequestDetail.insert_all!(edit_request_details)
    @record_created = true
  end

  def records_created?
    @record_created
  end

  private

  def check_associated_records_changes(records, attrs)
    return [] unless attrs

    edit_request_details = []

    attrs.each do |_, attr|
      record_id = attr[:id].to_i
      record = records.find { |r| r.id == record_id }
      next unless record

      edit_request_details += check_associated_record_changes(record, attr)
    end

    edit_request_details
  end

  def check_associated_record_changes(associated_record, attrs) # rubocop:disable Metrics/MethodLength
    return [] unless attrs

    associated_record.assign_attributes(attrs)

    edit_request_details = []
    associated_record.changes.each do |field, values|
      edit_request_details << {
        edit_request_id: @edit_request.id,
        field_name: EditRequestDetail.field_types[field],
        old_value: values[0],
        new_value: values[1],
        associated_record_id: associated_record.id,
        associated_record_type: associated_record.class.name,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    edit_request_details
  end
end
