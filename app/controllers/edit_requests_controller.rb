# frozen_string_literal: true

class EditRequestsController < ActionController::Base # :nodoc:
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    form = EditRequestForm.new(Issuer.find(params[:issuer_id]), issuer_params)

    if form.valid?
      ActiveRecord::Base.transaction do
        @edit_request = EditRequest.new(issuer_id: params[:issuer_id], status: :pending)

        @edit_request.save!

        EditRequestDetailsGenerator.new(@edit_request).call(issuer_params)
      end

      redirect_to issuer_path(params[:issuer_id]), notice: 'Edit request has been submitted.'
    else
      redirect_to edit_issuer_path(params[:issuer_id]), alert: 'Edit request failed to submit.'
    end
  end

  private

  def issuer_params # rubocop:disable Metrics/MethodLength
    params.require(:issuer).permit(
      :name_en, :name_fr, :description_en, :description_fr, :logo_url, :industry_id, :financial_year_end,
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
end
