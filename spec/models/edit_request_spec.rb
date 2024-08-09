# frozen_string_literal: true

require 'rails_helper'

describe EditRequest do
  describe '#requested_fields' do
    before do
      # To bypass the callback, we need to stub the method
      allow(EditRequestNotifier).to receive(:notify)
    end

    let(:issuer) { create(:issuer) }
    let(:edit_request) { create(:edit_request, issuer:) }
    let(:field_name) { :name_en }
    let!(:edit_request_detail) do
      create(:edit_request_detail, associated_record: issuer, field_name:, edit_request:)
    end

    it 'returns the requested fields' do
      expect(edit_request.requested_fields).to eq([field_name.to_s])
    end
  end
end
