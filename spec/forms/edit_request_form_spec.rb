# frozen_string_literal: true

require 'rails_helper'

describe EditRequestForm, type: :model do # rubocop:disable Metrics/BlockLength
  let(:industry) { create(:industry) }
  let(:issuer) { create(:issuer, industry:) }
  let(:company_link) { create(:company_link, issuer:) }
  let(:company_address) { create(:address, issuer:, address_type: :company) }
  let(:billing_address) { create(:address, issuer:, address_type: :billing) }
  let(:mailing_address) { create(:address, issuer:, address_type: :mailing) }
  let(:security_detail) { create(:security_detail, issuer:) }

  let(:issuer_params) do # rubocop:disable Metrics/BlockLength
    {
      name_en: 'Updated Issuer Name EN',
      name_fr: 'Updated Issuer Name FR',
      description_en: 'Updated Description EN',
      description_fr: 'Updated Description FR',
      logo_url: 'http://example.com/new_logo.png',
      industry_id: industry.id,
      financial_year_end: '2024-12-31',
      company_link_attributes: {
        id: company_link.id,
        linkedin_url: 'http://linkedin.com/new_profile',
        youtube_url: 'http://youtube.com/new_channel',
        instagram_url: 'http://instagram.com/new_profile'
      },
      company_addresses_attributes: {
        '0' => {
          id: company_address.id,
          country_id: company_address.country.id,
          address: 'Updated Company Address',
          city: 'Updated Company City',
          province_id: company_address.province.id,
          zip_code: '12345'
        }
      },
      billing_addresses_attributes: {
        '0' => {
          id: billing_address.id,
          country_id: billing_address.country.id,
          address: 'Updated Billing Address',
          city: 'Updated Billing City',
          province_id: billing_address.province.id,
          zip_code: '54321'
        }
      },
      mailing_addresses_attributes: {
        '0' => {
          id: mailing_address.id,
          country_id: mailing_address.country.id,
          address: 'Updated Mailing Address',
          city: 'Updated Mailing City',
          province_id: mailing_address.province.id,
          zip_code: '67890'
        }
      },
      security_details_attributes: {
        '0' => {
          id: security_detail.id,
          name_en: 'Updated Security EN',
          name_fr: 'Updated Security FR',
          issue_outstanding: 2000,
          reserved_for_issuance: 1000,
          total_equity_shares_as_if_converted: 3000
        }
      }
    }
  end

  subject { described_class.new(issuer, issuer_params) }

  describe '#valid?' do
    context 'when all attributes are valid' do
      it 'returns true' do
        expect(subject).to be_valid
      end
    end

    context 'when there are invalid attributes' do
      before do
        issuer_params[:name_en] = ''
        issuer_params[:company_addresses_attributes]['0'][:address] = ''
      end

      it 'returns false' do
        expect(subject).not_to be_valid
      end

      it 'adds errors from the issuer and associations' do
        subject.valid?
        expect(subject.errors.messages[:name_en]).to include("can't be blank")
        expect(subject.errors.messages[:'company_addresses.address']).to include("can't be blank")
      end
    end
  end

  describe 'associations' do
    it 'validates the associated records' do
      expect(subject).to be_valid
    end

    context 'when associated records are invalid' do
      before do
        issuer_params[:company_addresses_attributes]['0'][:address] = ''
        issuer_params[:security_details_attributes]['0'][:issue_outstanding] = -1
      end

      it 'adds errors from the associated records' do
        subject.valid?
        expect(subject.errors[:'company_addresses.address']).to include("can't be blank")
        expect(subject.errors[:'security_details.issue_outstanding']).to include('must be greater than or equal to 0')
      end
    end
  end
end
