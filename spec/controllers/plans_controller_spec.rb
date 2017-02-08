require 'rails_helper'

RSpec.describe PlansController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    describe 'when plan is found' do
      let!(:plan) { create(:plan) }

      it 'returns plan as json' do
        get :show, params: { id: plan.id }
        expect(response.body).to eq plan.to_json
      end
    end

    describe 'when plan is not found' do
      it '404s' do
        get :show, params: { id: 99 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET #search" do
    describe 'when a query param is present' do
      let!(:plan_one) { create(:plan, address: 'Dublin Road') }
      let!(:plan_two) { create(:plan, address: 'Malahide Road') }
      let(:query) { 'road' }

      it 'returns json search results' do
        get :search, params: { query: query }
        expect(response.body).to eq [plan_one, plan_two].to_json
      end
    end

    describe 'when a query param is not present' do
      it '400s' do
        get :search
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
