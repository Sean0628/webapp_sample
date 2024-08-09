# frozen_string_literal: true

require 'rails_helper'

describe External::IssuersExporter do # rubocop:disable Metrics/BlockLength
  describe '.export' do # rubocop:disable Metrics/BlockLength
    let!(:external_issuer) { create(:external_issuer) }
    let!(:company_link) { create(:external_company_link, external_issuer:) }
    let!(:address) { create(:external_address, external_issuer:) }
    let!(:security_detail) { create(:external_security_detail, external_issuer:) }

    it 'returns a JSON string' do
      result = described_class.export
      expect(result).to be_a(String)
      expect { JSON.parse(result) }.not_to raise_error
    end

    it 'includes issuer data with associations' do
      result = described_class.export
      json_result = JSON.parse(result)

      expect(json_result).to be_an(Array)
      expect(json_result.size).to eq(1)

      issuer_json = json_result.first
      expect(issuer_json['id']).to eq(external_issuer.id)
      expect(issuer_json['name_en']).to eq(external_issuer.name_en)
      expect(issuer_json['name_fr']).to eq(external_issuer.name_fr)
      expect(issuer_json['external_company_link']).to be_present
      expect(issuer_json['external_addresses']).to be_present
      expect(issuer_json['external_security_details']).to be_present
    end

    it 'includes only the specified attributes for associations' do
      result = described_class.export
      json_result = JSON.parse(result)

      issuer_json = json_result.first
      company_link_json = issuer_json['external_company_link']
      address_json = issuer_json['external_addresses'].first
      security_detail_json = issuer_json['external_security_details'].first

      # Check company link attributes
      expect(company_link_json['id']).to eq(company_link.id)
      expect(company_link_json['linkedin_url']).to eq(company_link.linkedin_url)
      expect(company_link_json['youtube_url']).to eq(company_link.youtube_url)
      expect(company_link_json['instagram_url']).to eq(company_link.instagram_url)
      expect(company_link_json.keys).not_to include('created_at', 'updated_at')

      # Check address attributes
      expect(address_json['id']).to eq(address.id)
      expect(address_json['external_country_id']).to eq(address.external_country_id)
      expect(address_json['external_province_id']).to eq(address.external_province_id)
      expect(address_json['city']).to eq(address.city)
      expect(address_json['address']).to eq(address.address)
      expect(address_json['zip_code']).to eq(address.zip_code)
      expect(address_json.keys).not_to include('created_at', 'updated_at')

      # Check security detail attributes
      expect(security_detail_json['id']).to eq(security_detail.id)
      expect(security_detail_json['name_en']).to eq(security_detail.name_en)
      expect(security_detail_json['name_fr']).to eq(security_detail.name_fr)
      expect(security_detail_json['issue_outstanding']).to eq(security_detail.issue_outstanding)
      expect(security_detail_json.keys).not_to include('created_at', 'updated_at')
    end
  end
end
