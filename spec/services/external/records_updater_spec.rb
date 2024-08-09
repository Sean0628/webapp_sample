# frozen_string_literal: true

require 'rails_helper'

describe External::RecordsUpdater do
  describe '.update' do
    let(:external_issuer) { create(:external_issuer) }
    let(:external_company_link) { create(:external_company_link, external_issuer:) }
    let(:external_address) { create(:external_address, external_issuer:) }
    let(:external_security_detail) { create(:external_security_detail, external_issuer:) }

    let(:details) do
      [
        build_stubbed(:external_edit_request_detail, associated_record: external_issuer, field_name: 'name_en',
                                                     new_value: 'New Issuer Name EN'),
        build_stubbed(:external_edit_request_detail, associated_record: external_company_link, field_name: 'linkedin_url',
                                                     new_value: 'https://new-linkedin.com'),
        build_stubbed(:external_edit_request_detail, associated_record: external_address, field_name: 'city',
                                                     new_value: 'New City'),
        build_stubbed(:external_edit_request_detail, associated_record: external_security_detail, field_name: 'issue_outstanding',
                                                     new_value: 2000)
      ]
    end

    before do
      External::RecordsUpdater.update(details)
    end

    it 'updates the issuer name' do
      external_issuer.reload
      expect(external_issuer.name_en).to eq('New Issuer Name EN')
    end

    it 'updates the company link' do
      external_company_link.reload
      expect(external_company_link.linkedin_url).to eq('https://new-linkedin.com')
    end

    it 'updates the address city' do
      external_address.reload
      expect(external_address.city).to eq('New City')
    end

    it 'updates the security detail issue outstanding' do
      external_security_detail.reload
      expect(external_security_detail.issue_outstanding).to eq(2000)
    end

    it 'raises an error if update fails' do
      allow_any_instance_of(ExternalAddress).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(external_address))

      expect do
        External::RecordsUpdater.update(details)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
