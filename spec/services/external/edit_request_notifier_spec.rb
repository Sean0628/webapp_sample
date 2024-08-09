# frozen_string_literal: true

require 'rails_helper'

describe External::EditRequestNotifier do
  describe '.notify' do
    # To bypass the callback, we need to stub the method
    before do
      allow(EditRequestNotifier).to receive(:notify)
    end

    let(:external_issuer) { create(:external_issuer) }
    let(:edit_request) { create(:external_edit_request, status: :pending, external_issuer:) }
    let!(:associated_edit_request) { create(:edit_request, external_id: edit_request.id, status: :pending) }

    it 'updates the status of the associated EditRequest' do
      expect do
        edit_request.update!(status: :approved)
      end.to change { associated_edit_request.reload.status }.from('pending').to('approved')
    end

    it 'does not update the status if no change in status' do
      expect do
        described_class.notify(edit_request)
      end.not_to change { associated_edit_request.reload.status }
    end
  end
end
