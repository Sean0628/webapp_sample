# frozen_string_literal: true

require 'rails_helper'

describe EditRequestDetailsGenerator do # rubocop:disable Metrics/BlockLength
  before do
    # To bypass the callback, we need to stub the method
    allow(EditRequestNotifier).to receive(:notify)
  end
  let(:industry) { create(:industry) }
  let(:issuer) { create(:issuer, industry:) }
  let(:edit_request) { create(:edit_request, issuer:) }
  let(:company_link) { create(:company_link, issuer:) }
  let(:company_address) { create(:address, issuer:, address_type: :company) }
  let(:billing_address) { create(:address, issuer:, address_type: :billing) }
  let(:mailing_address) { create(:address, issuer:, address_type: :mailing) }
  let(:security_detail) { create(:security_detail, issuer:) }

  let(:params) do # rubocop:disable Metrics/BlockLength
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
          city: company_address.city,
          province_id: company_address.province.id,
          zip_code: company_address.zip_code
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

  describe '#call' do
    it 'creates edit request details for changed fields' do
      generator = described_class.new(edit_request)
      expect { generator.call(params) }.to change(EditRequestDetail, :count).by_at_least(1)

      edit_request_detail = EditRequestDetail.last
      expect(edit_request_detail.edit_request).to eq(edit_request)
      expect(edit_request_detail.field_name).to eq('total_equity_shares_as_if_converted')
      expect(edit_request_detail.old_value).to eq(security_detail.total_equity_shares_as_if_converted.to_s)
      expect(edit_request_detail.new_value).to eq('3000')
    end

    it 'creates edit request details for associated records' do
      params[:company_addresses_attributes]['0'][:address] = 'New Company Address'
      generator = described_class.new(edit_request)
      expect { generator.call(params) }.to change(EditRequestDetail, :count).by_at_least(1)

      edit_request_detail = EditRequestDetail.find_by(associated_record_id: company_address.id,
                                                      associated_record_type: 'Address')
      expect(edit_request_detail.edit_request).to eq(edit_request)
      expect(edit_request_detail.field_name).to eq('address')
      expect(edit_request_detail.old_value).to eq(company_address.address)
      expect(edit_request_detail.new_value).to eq('New Company Address')
    end

    it 'does not create edit request details if there are no changes' do
      generator = described_class.new(edit_request)
      expect { generator.call({}) }.not_to change(EditRequestDetail, :count)
    end
  end
end
