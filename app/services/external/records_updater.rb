# frozen_string_literal: true

module External
  # This class is responsible for refrecting the changes made to the issuer and its associations.
  class RecordsUpdater
    def initialize(details)
      @details = details
    end

    def self.update(details)
      new(details).update
    end

    def update
      @details.each do |detail|
        associated_record = detail.associated_record
        field_name = detail.field_name
        new_value = detail.new_value

        associated_record.update!(field_name => new_value)
      end
    end
  end
end
