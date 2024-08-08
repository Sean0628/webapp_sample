# frozen_string_literal: true

require 'rails_helper'

describe EditRequestsController, type: :controller do # rubocop:disable Metrics/BlockLength
  describe 'POST #create' do # rubocop:disable Metrics/BlockLength
    let(:industry) { create(:industry) }
    let(:issuer) { create(:issuer, industry:) }
    let(:company_link) { create(:company_link, issuer:) }
    let(:company_address) { create(:address, address_type: :company, issuer:) }
    let(:billing_address) { create(:address, address_type: :billing, issuer:) }
    let(:mailing_address) { create(:address, address_type: :mailing, issuer:) }
    let(:security_detail) { create(:security_detail, issuer:) }

    let(:edit_request_params) do # rubocop:disable Metrics/BlockLength
      {
        issuer: {
          issuer_id: issuer.id,
          name_en: 'Issuer 1',
          name_fr: 'Émetteur 1',
          description_en: 'This is the first example issuer.',
          description_fr: 'Ceci est le premier émetteur exemple.',
          logo_url: 'http://example.com/logo1.png',
          industry_id: industry.id,
          financial_year_end: '2024-12-31',
          company_link_attributes: {
            id: company_link.id,
            linkedin_url: 'http://linkedin.com/example',
            youtube_url: 'http://youtube.com/example',
            instagram_url: 'http://instagram.com/example'
          },
          company_addresses_attributes: {
            '0' => {
              id: company_address.id,
              country_id: company_address.country_id,
              address: '123 Company St',
              city: 'Company City',
              province_id: company_address.province_id,
              zip_code: '12345'
            }
          },
          billing_addresses_attributes: {
            '0' => {
              id: billing_address.id,
              country_id: billing_address.country_id,
              address: '123 Billing St',
              city: 'Billing City',
              province_id: billing_address.province_id,
              zip_code: '54321'
            }
          },
          mailing_addresses_attributes: {
            '0' => {
              id: mailing_address.id,
              country_id: mailing_address.country_id,
              address: '123 Mailing St',
              city: 'Mailing City',
              province_id: mailing_address.province_id,
              zip_code: '67890'
            }
          },
          security_details_attributes: {
            '0' => {
              id: security_detail.id,
              name_en: 'Security 1',
              name_fr: 'Sécurité 1',
              issue_outstanding: '1000',
              reserved_for_issuance: '500',
              total_equity_shares_as_if_converted: '1500'
            }
          }
        }
      }
    end

    it 'creates a new edit request' do
      expect do
        post :create, params: edit_request_params
      end.to change(EditRequest, :count).by(1)
    end

    it 'redirects to the issuer show page' do
      post :create, params: edit_request_params
      expect(response).to redirect_to(issuer_path(issuer))
    end

    it 'sets a flash notice' do
      post :create, params: edit_request_params
      expect(flash[:notice]).to eq('Edit request has been submitted.')
    end

    context 'when the edit request is invalid' do
      let(:edit_request_params) do
        super().deep_merge(issuer: { name_en: nil })
      end

      it 'does not create a new edit request' do
        expect do
          post :create, params: edit_request_params
        end.not_to change(EditRequest, :count)
      end

      it 'redirects to the issuer edit page' do
        post :create, params: edit_request_params
        expect(response).to redirect_to(edit_issuer_path(issuer))
      end

      it 'sets a flash alert' do
        post :create, params: edit_request_params
        expect(flash[:alert]).to eq('Edit request failed to submit.')
      end
    end

    context 'when there are no changes detected' do
      before do
        allow_any_instance_of(EditRequestDetailsGenerator).to receive(:records_created?).and_return(false)
      end

      it 'does not create a new edit request' do
        expect do
          post :create, params: edit_request_params
        end.not_to change(EditRequest, :count)
      end

      it 'redirects to the issuer show page' do
        post :create, params: edit_request_params
        expect(response).to redirect_to(issuer_path(issuer))
      end

      it 'sets a flash alert' do
        post :create, params: edit_request_params
        expect(flash[:notice]).to eq('No changes detected. No edit request created.')
      end
    end
  end
end
