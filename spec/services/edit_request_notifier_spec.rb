# frozen_string_literal: true

require 'rails_helper'

describe EditRequestNotifier do
  describe '.notify' do
    let(:external_issuer) { create(:external_issuer) }
    let(:external_company_link) { create(:external_company_link) }

    let(:issuer) { create(:issuer, external_id: external_issuer.id) }
    let(:edit_request) { create(:edit_request, issuer:) }
    let(:company_link) { create(:company_link, external_id: external_company_link.id) }
    let(:edit_request_detail) do
      create(
        :edit_request_detail,
        edit_request:,
        field_name: 'linkedin_url',
        old_value: 'https://old-linkedin.com',
        new_value: 'https://new-linkedin.com',
        associated_record: company_link
      )
    end

    before do
      edit_request.edit_request_details << edit_request_detail
    end

    it 'creates an ExternalEditRequest' do
      expect do
        described_class.notify(edit_request)
      end.to change { ExternalEditRequest.count }.by(1)
    end

    it 'creates ExternalEditRequestDetails for each EditRequestDetail' do
      expect do
        described_class.notify(edit_request)
      end.to change { ExternalEditRequestDetail.count }.by(1)
    end

    it 'creates ExternalEditRequest with correct attributes' do
      described_class.notify(edit_request)

      external_request = ExternalEditRequest.last
      expect(external_request.external_issuer_id).to eq(issuer.external_id)
      expect(external_request.status).to eq('pending')
    end

    it 'creates ExternalEditRequestDetail with correct attributes' do
      described_class.notify(edit_request)

      external_request_detail = ExternalEditRequestDetail.last
      expect(external_request_detail.external_edit_request_id).to eq(ExternalEditRequest.last.id)
      expect(external_request_detail.field_name).to eq('linkedin_url')
      expect(external_request_detail.old_value).to eq('https://old-linkedin.com')
      expect(external_request_detail.new_value).to eq('https://new-linkedin.com')
      expect(external_request_detail.associated_record_id).to eq(company_link.external_id)
      expect(external_request_detail.associated_record_type).to eq('ExternalCompanyLink')
    end

    it 'wraps operations in a transaction' do
      allow(ExternalEditRequest).to receive(:create!).and_raise(ActiveRecord::Rollback)

      expect do
        described_class.notify(edit_request)
      rescue StandardError
        nil
      end.not_to change { ExternalEditRequest.count }
    end
  end
end
