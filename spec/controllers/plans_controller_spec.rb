require 'rails_helper'

RSpec.describe PlansController, type: :controller do

  describe "GET #index" do
    let!(:plans) { 100.times { create(:plan) } }

    it "paginates plans in batches of 50" do
      get :index
      expect(JSON.parse(response.body).length).to eq 50
    end

    it 'include link headers' do
      get :index
      expect(response.headers['Link']).to include 'next'
      expect(response.headers['Per-Page']).to eq '50'
      expect(response.headers['Total']).to eq '100'
    end

    it 'does not include an audit trail' do
      Plan.update_all(address: 'new_address')
      get :index
      plan = JSON.parse(response.body)[0]
      expect(plan.keys).not_to include 'audits'
    end
  end

  describe 'GET #show' do
    describe 'when plan is found' do
      let!(:plan) { create(:plan) }

      it 'returns plan as json' do
        get :show, params: { id: plan.id }
        expect(response.body).to eq PlanSerializer.new(plan, with_audits: true).to_json
      end

      it 'includes any audit trails' do
        plan.update_attributes(address: 'new address')
        get :show, params: { id: plan.id }
        expect(JSON.parse(response.body).keys).to include 'audits'
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
        json = [plan_one, plan_two].map {| p| PlanSerializer.new(p) }.to_json
        expect(response.body).to eq json
      end
    end

    describe 'when a query param is not present' do
      it '400s' do
        get :search
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET #within" do
    describe "when all query params are present" do
      let!(:plan_one) { create(:plan) }
      let(:lat) { '53.397' }
      let(:lng) { '6.2002' }
      let(:latlng) { "#{lat}#{lng}" }
      let(:kilometres) { "5" }

      it 'returns json search results' do
        expect(Plan).to receive(:within_kilometres_of).with(kilometres, latlng.split(',')).and_return [plan_one]
        get :within, params: { latlng: latlng, kilometres: kilometres }
        expect(response.body).to eq [PlanSerializer.new(plan_one)].to_json
      end
    end

    describe "when a query param is missing" do
      it '400s' do
        get :within, params: { latlng: '53.1,-6.5' }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#decided' do
    let!(:plan) { create(:plan, status: 'Decided') }

    it "paginates decided plans" do
      get :decided
      body = JSON.parse(response.body)
      expect(body[0]['status']).to eq 'Decided'
    end
  end

  describe '#invalid' do
    let!(:plan) { create(:plan, status: 'Invalid or Withdrawn') }

    it "paginates invalid plans" do
      get :invalid
      body = JSON.parse(response.body)
      expect(body[0]['status']).to eq 'Invalid or Withdrawn'
    end
  end

  describe '#unknown' do
    let!(:plan) { create(:plan, status: 'Current status not assigned in APAS') }

    it "paginates unknown plans" do
      get :unknown
      body = JSON.parse(response.body)
      expect(body[0]['status']).to eq 'Current status not assigned in APAS'
    end
  end

  describe '#pending' do
    let!(:plan) { create(:plan, status: 'Pending') }

    it "paginates pending plans" do
      get :pending
      body = JSON.parse(response.body)
      expect(body[0]['status']).to eq 'Pending'
    end
  end

  describe '#on_appeal' do
    let!(:plan) { create(:plan, status: 'On Appeal') }

    it "paginates on_appeal plans" do
      get :on_appeal
      body = JSON.parse(response.body)
      expect(body[0]['status']).to eq 'On Appeal'
    end
  end

  describe '#recently_registered' do
    let!(:plan) { create(:plan, registration_date: 1.week.ago.to_date) }

    it "paginates recently_registered plans" do
      get :recently_registered
      body = JSON.parse(response.body)
      expect(body[0]['registration_date']).to be > 1.month.ago
    end
  end

  describe '#recently_decided' do
    let!(:plan) { create(:plan, decision_date: 1.week.ago.to_date) }

    it "paginates recently_decided plans" do
      get :recently_decided
      body = JSON.parse(response.body)
      expect(body[0]['decision_date']).to be > 1.month.ago
    end
  end
end
