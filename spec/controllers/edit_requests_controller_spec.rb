# frozen_string_literal: true

require 'rails_helper'

describe EditRequestsController, type: :controller do # rubocop:disable Metrics/BlockLength
  describe 'GET #index' do
    let(:external_issuer) { create(:external_issuer) }
    let!(:issuer) { create(:issuer, external_id: external_issuer.id) }
    let!(:pending_edit_request) { create(:edit_request, issuer:, status: :pending) }
    let!(:approved_edit_request) { create(:edit_request, issuer:, status: :approved) }
    let!(:rejected_edit_request) { create(:edit_request, issuer:, status: :rejected) }

    before { get :index }

    it 'only assigns pending edit requests' do
      expect(assigns(:pending_edit_requests)).to eq([pending_edit_request])
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do # rubocop:disable Metrics/BlockLength
    let(:external_issuer) { create(:external_issuer) }
    let(:external_company_link) { create(:external_company_link, external_issuer:) }
    let(:external_company_address) { create(:external_address, address_type: :company, external_issuer:) }
    let(:external_billing_address) { create(:external_address, address_type: :billing, external_issuer:) }
    let(:external_mailing_address) { create(:external_address, address_type: :mailing, external_issuer:) }
    let(:external_security_detail) { create(:external_security_detail, external_issuer:) }
    let(:industry) { create(:industry) }
    let(:issuer) { create(:issuer, external_id: external_issuer.id, industry:) }
    let(:company_link) { create(:company_link, external_id: external_company_link.id, issuer:) }
    let(:company_address) do
      create(:address, address_type: :company, external_id: external_company_address.id, issuer:)
    end
    let(:billing_address) do
      create(:address, address_type: :billing, external_id: external_billing_address.id, issuer:)
    end
    let(:mailing_address) do
      create(:address, address_type: :mailing, external_id: external_mailing_address.id, issuer:)
    end
    let(:security_detail) { create(:security_detail, external_id: external_security_detail.id, issuer:) }

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
