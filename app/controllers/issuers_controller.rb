# frozen_string_literal: true

class IssuersController < ActionController::Base # :nodoc:
  def index
    @issuers = Issuer.all
  end

  def show
    @issuer = Issuer.find(params[:id])
  end
end
