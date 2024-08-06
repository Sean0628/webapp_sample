# frozen_string_literal: true

class IssuersController < ActionController::Base # :nodoc:
  NOT_FOUND_MESSAGE = 'The issuer you are looking for could not be found.'

  def index
    @issuers = Issuer.all
  end

  def show
    @issuer = Issuer.includes(:industry, :company_link, :company_addresses, :mailing_addresses, :billing_addresses,
                              :security_details).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = NOT_FOUND_MESSAGE
    redirect_to issuers_path
  end
end
