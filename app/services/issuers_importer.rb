# frozen_string_literal: true

# This class is responsible for importing issuers from an external source.
# It fetches the external data, upserts the issuers, and upserts the associated
# company links, addresses, and security details.
class IssuersImporter
  def self.import!
    new.execute
  end

  def execute
    issuers_data = fetch_external_data
    upsert_issuers(issuers_data)
  end

  private

  def fetch_external_data
    JSON.parse(External::IssuersExporter.export)
  end

  def upsert_issuers(issuers_data) # rubocop:disable Metrics/MethodLength
    issuers_data.each do |issuer_data|
      issuer = Issuer.find_or_initialize_by(external_id: issuer_data['id'])
      issuer_data.tap { |data| data['industry_id'] = data.delete('external_industry_id') }
      issuer.assign_attributes(
        issuer_data.except(
          'external_company_link',
          'external_addresses',
          'external_security_details'
        )
      )
      issuer.save!

      upsert_company_link(issuer, issuer_data['external_company_link'])
      upsert_addresses(issuer, issuer_data['external_addresses'])
      upsert_security_details(issuer, issuer_data['external_security_details'])
    end
  end

  def upsert_company_link(issuer, company_link_data)
    return unless company_link_data

    company_link = CompanyLink.find_or_initialize_by(external_id: company_link_data['id'])
    company_link.issuer_id = issuer.id
    company_link.update!(company_link_data)
  end

  def upsert_addresses(issuer, addresses_data)
    return unless addresses_data

    addresses_data.each do |address_data|
      address = Address.find_or_initialize_by(external_id: address_data['id'])
      address.issuer_id = issuer.id

      address_data.tap do |data|
        data['country_id'] = data.delete('external_country_id')
        data['province_id'] = data.delete('external_province_id')
      end

      address.update!(address_data)
    end
  end

  def upsert_security_details(issuer, security_details_data)
    return unless security_details_data

    security_details_data.each do |security_data|
      security_detail = SecurityDetail.find_or_initialize_by(external_id: security_data['id'])
      security_detail.issuer_id = issuer.id
      security_detail.update!(security_data)
    end
  end
end
