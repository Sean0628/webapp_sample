# frozen_string_literal: true

class IssuersController < ActionController::Base # :nodoc:
  def index
    @issuers = Issuer.all
  end
end
