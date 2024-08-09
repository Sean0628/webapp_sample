# frozen_string_literal: true

class IssuersImportJob < ApplicationJob # :nodoc:
  queue_as :default

  def perform
    IssuersImporter.import!
  end
end
