# frozen_string_literal: true

module External
  class IssuersExporter
    ASSOCIATIONS = %i[external_company_link external_addresses external_security_details].freeze

    def self.export
      new.execute
    end

    def execute
      issuers_data = ExternalIssuer.includes(ASSOCIATIONS).map do |issuer|
        Formatter.call(issuer)
      end

      JSON.pretty_generate(issuers_data)
    end

    module Formatter
      def call(issuer)
        issuer.as_json(include: {
                         external_company_link: {
                           only: %i[id linkedin_url youtube_url instagram_url]
                         },
                         external_addresses: {
                           only: %i[id external_country_id external_province_id city address zip_code address_type]
                         },
                         external_security_details: {
                           only: %i[id name_en name_fr issue_outstanding reserved_for_issuance
                                    total_equity_shares_as_if_converted]
                         }
                       })
      end

      module_function :call
    end
  end
end
