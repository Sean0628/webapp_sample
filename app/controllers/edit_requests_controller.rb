# frozen_string_literal: true

class EditRequestsController < ActionController::Base # :nodoc:
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @form = EditRequestForm.new(issuer, issuer_params.except(:issuer_id))

    if @form.valid?
      msg = 'Edit request has been submitted.'

      ActiveRecord::Base.transaction do
        @edit_request = EditRequest.new(issuer_id: issuer.id, status: :pending)
        @edit_request.save!

        edit_request_generator.call(issuer_params.except(:issuer_id))

        puts 'Records created?'
        puts edit_request_generator.records_created?

        unless edit_request_generator.records_created?
          msg = 'No changes detected. Edit request failed to submit.'
          raise ActiveRecord::Rollback
        end
      end

      redirect_to issuer_path(issuer), notice: msg
    else
      redirect_to edit_issuer_path(issuer), alert: 'Edit request failed to submit.'
    end
  end

  private

  def issuer_params # rubocop:disable Metrics/MethodLength
    params.require(:issuer).permit(
      :name_en, :name_fr, :description_en, :description_fr, :logo_url, :industry_id, :financial_year_end, :issuer_id,
      company_link_attributes: %i[id linkedin_url youtube_url instagram_url],
      company_addresses_attributes: %i[id country_id address city province_id zip_code _destroy],
      billing_addresses_attributes: %i[id country_id address city province_id zip_code _destroy],
      mailing_addresses_attributes: %i[id country_id address city province_id zip_code _destroy],
      security_details_attributes: %i[
        id
        security_name_en
        security_name_fr
        issues_outstanding
        reserved_for_issuance
        total_equity_shares_as_if_converted
        _destroy
      ]
    )
  end

  def issuer
    @issuer ||= Issuer.find(issuer_params[:issuer_id])
  end

  def edit_request_generator
    @edit_request_generator ||= EditRequestDetailsGenerator.new(@edit_request)
  end
end
