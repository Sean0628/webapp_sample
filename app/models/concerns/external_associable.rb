# frozen_string_literal: true

module ExternalAssociable # :nodoc:
  extend ActiveSupport::Concern

  included do
    def external_type
      "external_#{self.class.name.underscore}"
    end
  end
end
