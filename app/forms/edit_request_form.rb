# frozen_string_literal: true

# This class is responsible for handling the edit request form.
class EditRequestForm
  include ActiveModel::Model

  delegate :errors, to: :issuer

  def initialize(issuer, issuer_params)
    @issuer = issuer
    @issuer_params = issuer_params

    assign_attributes(issuer_params)
  end

  def valid?
    super && issuer.valid?
  end

  private

  attr_reader :issuer, :issuer_params

  def assign_attributes(attrs)
    issuer.assign_attributes(attrs)
  end
end
