# frozen_string_literal: true

require 'rails_helper'

describe IssuersImporter do
  describe '.import!' do
    let(:issuer_data) do
      {
        'id' => 1,
        'name_en' => 'Example Company',
        'name_fr' => 'Société Exemple',
        'description_en' => 'Description in English',
        'description_fr' => 'Description en Français',
        'logo_url' => 'https://example.com/logo.png',
        'industry_id' => industry.id,
        'financial_year_end' => '2023-12-31',
        'external_company_link' => {
          'id' => 1,
          'linkedin_url' => 'https://linkedin.com/company',
          'youtube_url' => 'https://youtube.com/channel',
          'instagram_url' => 'https://instagram.com/profile'
        },
        'external_addresses' => [
          {
            'id' => 1,
            'external_country_id' => country.id,
            'external_province_id' => province.id,
            'city' => 'City Name',
            'address' => '123 Street Name',
            'zip_code' => '12345',
            'address_type' => 0
          }
        ],
        'external_security_details' => [
          {
            'id' => 1,
            'name_en' => 'Common Stock',
            'name_fr' => 'Action Ordinaire',
            'issue_outstanding' => 1000,
            'reserved_for_issuance' => 500,
            'total_equity_shares_as_if_converted' => 1500
          }
        ]
      }
    end

    let(:external_exporter_double) { instance_double('External::IssuersExporter', export: [issuer_data].to_json) }

    let(:industry) { create(:industry) }
    let(:country) { create(:country) }
    let(:province) { create(:province) }

    before do
      allow(External::IssuersExporter).to receive(:export).and_return([issuer_data].to_json)
    end

    it 'fetches external data' do
      expect(External::IssuersExporter).to receive(:export).and_return([issuer_data].to_json)
      described_class.import!
    end

    it 'upserts issuers' do
      expect do
        described_class.import!
      end.to change { Issuer.count }.by(1)

      issuer = Issuer.find_by(external_id: 1)
      expect(issuer.name_en).to eq('Example Company')
      expect(issuer.name_fr).to eq('Société Exemple')
      expect(issuer.description_en).to eq('Description in English')
      expect(issuer.description_fr).to eq('Description en Français')
    end

    it 'upserts company links' do
      expect do
        described_class.import!
      end.to change { CompanyLink.count }.by(1)

      company_link = CompanyLink.find_by(external_id: 1)
      expect(company_link.linkedin_url).to eq('https://linkedin.com/company')
      expect(company_link.youtube_url).to eq('https://youtube.com/channel')
      expect(company_link.instagram_url).to eq('https://instagram.com/profile')
    end

    it 'upserts addresses' do
      expect do
        described_class.import!
      end.to change { Address.count }.by(1)

      address = Address.find_by(external_id: 1)
      expect(address.city).to eq('City Name')
      expect(address.address).to eq('123 Street Name')
      expect(address.zip_code).to eq('12345')
      expect(address.address_type).to eq('company')
    end

    it 'upserts security details' do
      expect do
        described_class.import!
      end.to change { SecurityDetail.count }.by(1)

      security_detail = SecurityDetail.find_by(external_id: 1)
      expect(security_detail.name_en).to eq('Common Stock')
      expect(security_detail.name_fr).to eq('Action Ordinaire')
      expect(security_detail.issue_outstanding).to eq(1000)
      expect(security_detail.reserved_for_issuance).to eq(500)
      expect(security_detail.total_equity_shares_as_if_converted).to eq(1500)
    end
  end
end
