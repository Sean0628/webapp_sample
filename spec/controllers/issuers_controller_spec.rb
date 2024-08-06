# frozen_string_literal: true

require 'rails_helper'

describe IssuersController, type: :controller do # rubocop:disable Lint/BlockLength
  describe 'GET #index' do
    let!(:issuer1) { create(:issuer) }
    let!(:issuer2) { create(:issuer) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @issuers' do
      get :index
      expect(assigns(:issuers)).to match_array([issuer1, issuer2])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let!(:issuer) { create(:issuer) }

    it 'returns a successful response' do
      get :show, params: { id: issuer.id }
      expect(response).to be_successful
    end

    it 'assigns @issuer' do
      get :show, params: { id: issuer.id }
      expect(assigns(:issuer)).to eq(issuer)
    end

    it 'renders the show template' do
      get :show, params: { id: issuer.id }
      expect(response).to render_template(:show)
    end
  end
end
